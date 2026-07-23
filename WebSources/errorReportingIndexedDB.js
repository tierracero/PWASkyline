const DATABASE_NAME = 'PWASkylineDiagnostics'
const DATABASE_VERSION = 2
const STORE_NAME = 'errorReports'
const DUPLICATE_WINDOW_SECONDS = 5 * 60
const MAX_RETRY_ATTEMPTS = 50

let databasePromise

function asError(error) {
    if (!error) return 'Unknown IndexedDB error'
    return String(error.message || error.name || error)
}

function complete(callback, value, error) {
    callback(value === undefined ? '' : JSON.stringify(value), error ? asError(error) : null)
}

function openDatabase() {
    if (databasePromise) return databasePromise

    databasePromise = new Promise((resolve, reject) => {
        const request = indexedDB.open(DATABASE_NAME, DATABASE_VERSION)

        request.onupgradeneeded = event => {
            const database = request.result
            const store = database.objectStoreNames.contains(STORE_NAME)
                ? request.transaction.objectStore(STORE_NAME)
                : database.createObjectStore(STORE_NAME, { keyPath: 'id' })

            const indexes = [
                'createdAt',
                'expiresAt',
                'reported',
                'nextRetryAt',
                'username',
                'fingerprint',
                'inFlightUntil',
                'priorityRank'
            ]

            for (const index of indexes) {
                if (!store.indexNames.contains(index)) {
                    store.createIndex(index, index, { unique: false })
                }
            }

            if (event.oldVersion < 2) {
                const cursorRequest = store.openCursor()
                cursorRequest.onsuccess = () => {
                    const cursor = cursorRequest.result
                    if (!cursor) return
                    cursor.update(normalizePriority(cursor.value))
                    cursor.continue()
                }
            }
        }

        request.onsuccess = () => {
            const database = request.result
            database.onversionchange = () => database.close()
            resolve(database)
        }
        request.onerror = () => {
            databasePromise = undefined
            reject(request.error)
        }
        request.onblocked = () => {
            databasePromise = undefined
            reject(new Error('IndexedDB upgrade blocked by another tab'))
        }
    })

    return databasePromise
}

async function withTransaction(mode, callback) {
    const database = await openDatabase()
    return new Promise((resolve, reject) => {
        const transaction = database.transaction(STORE_NAME, mode)
        const store = transaction.objectStore(STORE_NAME)
        let result
        let callbackError

        try {
            callback(store, value => { result = value })
        } catch (error) {
            callbackError = error
            transaction.abort()
        }

        transaction.oncomplete = () => resolve(result)
        transaction.onerror = () => reject(transaction.error || callbackError)
        transaction.onabort = () => reject(transaction.error || callbackError || new Error('IndexedDB transaction aborted'))
    })
}

function normalizePriority(record) {
    const aliases = { medium: 'med', critical: 'high' }
    const priorty = aliases[record.priorty] || record.priorty
    const ranks = { zero: 0, low: 1, med: 2, high: 3 }
    record.priorty = Object.prototype.hasOwnProperty.call(ranks, priorty) ? priorty : 'zero'
    record.priorityRank = ranks[record.priorty]
    return record
}

function comparePendingRecords(left, right) {
    return (right.priorityRank - left.priorityRank) ||
        (left.createdAt - right.createdAt) ||
        ((left.retries || 0) - (right.retries || 0))
}

function open(callback) {
    openDatabase().then(() => complete(callback, { opened: true })).catch(error => complete(callback, undefined, error))
}

function save(recordJSON, callback) {
    let incoming
    try {
        incoming = normalizePriority(JSON.parse(recordJSON))
    } catch (error) {
        complete(callback, undefined, error)
        return
    }

    withTransaction('readwrite', (store, setResult) => {
        const request = store.index('fingerprint').getAll(incoming.fingerprint)
        request.onerror = () => { throw request.error }
        request.onsuccess = () => {
            const duplicate = request.result
                .filter(record => !record.reported && record.lastOccurredAt >= incoming.createdAt - DUPLICATE_WINDOW_SECONDS)
                .filter(record => record.username === incoming.username)
                .filter(record => record.accountId === incoming.accountId)
                .sort((left, right) => right.lastOccurredAt - left.lastOccurredAt)[0]

            if (duplicate) {
                duplicate.lastOccurredAt = Math.max(duplicate.lastOccurredAt, incoming.lastOccurredAt)
                duplicate.occurrenceCount = (duplicate.occurrenceCount || 1) + (incoming.occurrenceCount || 1)
                if (incoming.priorityRank > duplicate.priorityRank) {
                    duplicate.priorityRank = incoming.priorityRank
                    duplicate.priorty = incoming.priorty
                }
                duplicate.responsePayload = incoming.responsePayload
                duplicate.httpStatus = incoming.httpStatus
                duplicate.httpStatusText = incoming.httpStatusText
                duplicate.error = incoming.error
                normalizePriority(duplicate)
                store.put(duplicate)
                setResult(duplicate)
                return
            }

            store.put(incoming)
            setResult(incoming)
        }
    }).then(value => complete(callback, value)).catch(error => complete(callback, undefined, error))
}

function saveCompleted(recordJSON, callback) {
    let completedRecord
    try {
        completedRecord = normalizePriority(JSON.parse(recordJSON))
        completedRecord.reported = true
        completedRecord.inFlightUntil = null
        completedRecord.nextRetryAt = null
        completedRecord.lastReportingError = null
    } catch (error) {
        complete(callback, undefined, error)
        return
    }

    withTransaction('readwrite', (store, setResult) => {
        const request = store.put(completedRecord)
        request.onsuccess = () => setResult(completedRecord)
    }).then(value => complete(callback, value)).catch(error => complete(callback, undefined, error))
}

function getRecords(callback) {
    withTransaction('readonly', (store, setResult) => {
        const request = store.getAll()
        request.onsuccess = () => setResult(request.result)
    }).then(value => complete(callback, value)).catch(error => complete(callback, undefined, error))
}

function findRecentByFingerprint(fingerprint, since, callback) {
    withTransaction('readonly', (store, setResult) => {
        const request = store.index('fingerprint').getAll(fingerprint)
        request.onsuccess = () => {
            const result = request.result
                .filter(record => !record.reported && record.lastOccurredAt >= since)
                .sort((left, right) => right.lastOccurredAt - left.lastOccurredAt)[0] || null
            setResult(result)
        }
    }).then(value => complete(callback, value)).catch(error => complete(callback, undefined, error))
}

function claimPending(username, accountId, now, limit, leaseUntil, callback) {
    withTransaction('readwrite', (store, setResult) => {
        const request = store.getAll()
        request.onsuccess = () => {
            const records = request.result
                .filter(record => !record.reported)
                .filter(record => (record.retries || 0) < MAX_RETRY_ATTEMPTS)
                .filter(record => !record.nextRetryAt || record.nextRetryAt <= now)
                .filter(record => !record.inFlightUntil || record.inFlightUntil <= now)
                .filter(record => record.username === username)
                .filter(record => !accountId || !record.accountId || record.accountId === accountId)
                .sort(comparePendingRecords)
                .slice(0, limit)

            for (const record of records) {
                record.inFlightUntil = leaseUntil
                store.put(record)
            }
            setResult(records)
        }
    }).then(value => complete(callback, value)).catch(error => complete(callback, undefined, error))
}

function updateRecord(id, mutation, callback) {
    withTransaction('readwrite', (store, setResult) => {
        const request = store.get(id)
        request.onsuccess = () => {
            const record = request.result
            if (!record) {
                setResult(null)
                return
            }
            mutation(record)
            store.put(record)
            setResult(record)
        }
    }).then(value => complete(callback, value)).catch(error => complete(callback, undefined, error))
}

function markReported(id, reportedAt, callback) {
    updateRecord(id, record => {
        record.reported = true
        record.reportedAt = reportedAt
        record.inFlightUntil = null
        record.lastReportingError = null
    }, callback)
}

function recordFailure(id, attemptedAt, nextRetryAt, reportingError, callback) {
    updateRecord(id, record => {
        record.retries = (record.retries || 0) + 1
        record.lastAttemptAt = attemptedAt
        record.nextRetryAt = nextRetryAt
        record.lastReportingError = reportingError
        record.inFlightUntil = null
    }, callback)
}

function releaseClaim(id, callback) {
    updateRecord(id, record => { record.inFlightUntil = null }, callback)
}

function deleteExpired(now, callback) {
    withTransaction('readwrite', (store, setResult) => {
        const request = store.openCursor()
        let deleted = 0
        request.onsuccess = () => {
            const cursor = request.result
            if (!cursor) {
                setResult({ deleted })
                return
            }
            if (cursor.value.expiresAt <= now) {
                cursor.delete()
                deleted += 1
            }
            cursor.continue()
        }
    }).then(value => complete(callback, value)).catch(error => complete(callback, undefined, error))
}

function countPending(username, callback) {
    withTransaction('readonly', (store, setResult) => {
        const request = store.getAll()
        request.onsuccess = () => setResult(request.result.filter(record => !record.reported && (!username || record.username === username)).length)
    }).then(value => complete(callback, value)).catch(error => complete(callback, undefined, error))
}

globalThis.PWASkylineErrorStore = Object.freeze({
    open,
    save,
    saveCompleted,
    getRecords,
    findRecentByFingerprint,
    claimPending,
    markReported,
    recordFailure,
    releaseClaim,
    deleteExpired,
    countPending
})
