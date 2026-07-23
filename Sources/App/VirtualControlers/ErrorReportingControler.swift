import Foundation
import TCFundamentals
import Web

enum ErrorReportingFlushReason: String {
    case startup
    case scheduled
    case sessionAvailable
    case applicationActive
    case online
    case immediate
}

final class ErrorReportingControler {
    static let shared = ErrorReportingControler()

    private let store = ErrorReportingIndexedDBBridge.shared
    private let retryInterval: Int64 = 10 * 60
    private let retentionInterval: Int64 = 60 * 24 * 60 * 60
    private let claimInterval: Int64 = 2 * 60
    private let batchLimit = 20
    private let fallbackLimit = 50

    private var hasStarted = false
    private var flushIsRunning = false
    private var scheduledFlushGeneration = 0
    private var storageIsAvailable = false
    private var fallbackQueue: [ErrorReportRecord] = []

    private init() {}

    func start() {
        guard !hasStarted else { return }
        hasStarted = true

        WebApp.shared.window.$isOnline.listenOnlyIfChanged { isOnline in
            guard isOnline else { return }
            self.flushPendingReports(reason: .online)
        }

        openStore { opened in
            if opened {
                self.cleanupExpiredReports()
                self.flushPendingReports(reason: .startup)
            }
        }
        scheduleNextFlush()
    }

    func sessionDidBecomeAvailable() {
        flushPendingReports(reason: .sessionAvailable)
    }

    func applicationDidBecomeActive() {
        cleanupExpiredReports()
        flushPendingReports(reason: .applicationActive)
    }

    func report(_ record: ErrorReportRecord) {
        Web.Dispatch.async {
            self.enqueue(record)
        }
    }

    func getRecords(
        completion: @escaping (Result<[ErrorReportRecord], ErrorReportingStoreError>) -> Void
    ) {
        let fallbackSnapshot = fallbackQueue
        guard storageIsAvailable else {
            openStore { opened in
                guard opened else {
                    if self.fallbackQueue.isEmpty {
                        completion(.failure(.unavailable))
                    } else {
                        completion(.success(self.sortedRecords(self.fallbackQueue)))
                    }
                    return
                }
                self.loadRecords(additionalRecords: fallbackSnapshot, completion: completion)
            }
            return
        }

        loadRecords(additionalRecords: fallbackSnapshot, completion: completion)
    }

    func reportTransportError(
        category: ErrorReportType,
        priorty requestedPriorty: TCFundamentals.ErrorReportingPriorty,
        context: HTTPRequestDiagnosticContext,
        title: String,
        error: String,
        responsePayload: String? = nil,
        httpStatus: Int? = nil,
        httpStatusText: String? = nil
    ) {
        let priorty = resolvedPriorty(for: category, requested: requestedPriorty, httpStatus: httpStatus)
        report(makeRecord(
            category: category,
            priorty: priorty,
            context: context,
            title: title,
            error: error,
            responsePayload: responsePayload,
            httpStatus: httpStatus,
            httpStatusText: httpStatusText
        ))
    }

    func reportDecodingError(
        priorty: TCFundamentals.ErrorReportingPriorty,
        responseType: String,
        error: Error,
        responseData: Foundation.Data,
        context: HTTPRequestDiagnosticContext?,
        file: String,
        line: Int,
        function: String
    ) {
        let diagnosticContext = context ?? fallbackContext(
            priorty: priorty,
            file: file,
            line: line,
            function: function
        )
        let response = String(data: responseData, encoding: .utf8)
        reportTransportError(
            category: .decoding,
            priorty: .high.raised(to: priorty),
            context: diagnosticContext,
            title: "API response decoding failed: \(responseType)",
            error: errorReportingDecodingDescription(error),
            responsePayload: response
        )
    }

    func reportAPIError(
        priorty: TCFundamentals.ErrorReportingPriorty,
        responseType: String,
        responseData: Foundation.Data,
        context: HTTPRequestDiagnosticContext?,
        file: String,
        line: Int,
        function: String
    ) {
        let diagnosticContext = context ?? fallbackContext(
            priorty: priorty,
            file: file,
            line: line,
            function: function
        )
        reportTransportError(
            category: .api,
            priorty: priorty,
            context: diagnosticContext,
            title: "API requested session termination: \(responseType)",
            error: "The decoded API response returned status kill.",
            responsePayload: String(data: responseData, encoding: .utf8)
        )
    }

    func flushPendingReports(reason: ErrorReportingFlushReason) {
        guard !flushIsRunning else { return }
        guard hasActiveSession else { return }

        if !storageIsAvailable {
            openStore { opened in
                if opened {
                    self.flushPendingReports(reason: reason)
                }
            }
            return
        }

        flushIsRunning = true
        let now = getNow()
        store.deleteExpired(now: now) {
            self.store.claimPending(
                username: custCatchUser,
                accountId: custCatchID,
                now: now,
                limit: self.batchLimit,
                leaseUntil: now + self.claimInterval
            ) { result in
                switch result {
                case .success(let records):
                    self.deliver(records, at: 0) {
                        self.flushIsRunning = false
                    }
                case .failure:
                    self.storageIsAvailable = false
                    self.flushIsRunning = false
                }
            }
        }
    }

    func cleanupExpiredReports() {
        guard storageIsAvailable else { return }
        store.deleteExpired(now: getNow())
    }

    private var hasActiveSession: Bool {
        !custCatchUser.isEmpty && !custCatchToken.isEmpty
    }

    private func openStore(completion: @escaping (Bool) -> Void) {
        store.open { result in
            switch result {
            case .success:
                self.storageIsAvailable = true
                self.drainFallbackQueue()
                completion(true)
            case .failure:
                self.storageIsAvailable = false
                completion(false)
            }
        }
    }

    private func enqueue(_ record: ErrorReportRecord) {
        guard storageIsAvailable else {
            addToFallback(record)
            openStore { _ in }
            return
        }

        store.save(record) { result in
            switch result {
            case .success(let persisted):
                if persisted.priorty.diagnosticRank >= TCFundamentals.ErrorReportingPriorty.high.diagnosticRank {
                    self.flushPendingReports(reason: .immediate)
                }
            case .failure:
                self.storageIsAvailable = false
                self.addToFallback(record)
            }
        }
    }

    private func loadRecords(
        additionalRecords: [ErrorReportRecord],
        completion: @escaping (Result<[ErrorReportRecord], ErrorReportingStoreError>) -> Void
    ) {
        store.getRecords { result in
            switch result {
            case .success(let persistedRecords):
                completion(.success(self.mergedRecords(
                    persistedRecords,
                    additionalRecords: additionalRecords
                )))
            case .failure(let error):
                self.storageIsAvailable = false
                let localRecords = self.mergedRecords(
                    [],
                    additionalRecords: additionalRecords
                )
                if localRecords.isEmpty {
                    completion(.failure(error))
                } else {
                    completion(.success(localRecords))
                }
            }
        }
    }

    private func mergedRecords(
        _ persistedRecords: [ErrorReportRecord],
        additionalRecords: [ErrorReportRecord]
    ) -> [ErrorReportRecord] {
        var recordsById: [UUID: ErrorReportRecord] = [:]
        additionalRecords.forEach { recordsById[$0.id] = $0 }
        fallbackQueue.forEach { recordsById[$0.id] = $0 }
        persistedRecords.forEach { recordsById[$0.id] = $0 }
        return sortedRecords(Array(recordsById.values))
    }

    private func sortedRecords(_ records: [ErrorReportRecord]) -> [ErrorReportRecord] {
        records.sorted {
            if $0.reported != $1.reported { return !$0.reported }
            if $0.lastOccurredAt != $1.lastOccurredAt { return $0.lastOccurredAt > $1.lastOccurredAt }
            return $0.createdAt > $1.createdAt
        }
    }

    private func addToFallback(_ record: ErrorReportRecord) {
        fallbackQueue.append(record)
        guard fallbackQueue.count > fallbackLimit else { return }

        fallbackQueue.sort {
            if $0.priorityRank != $1.priorityRank { return $0.priorityRank < $1.priorityRank }
            return $0.createdAt < $1.createdAt
        }
        fallbackQueue.removeFirst()
    }

    private func drainFallbackQueue() {
        guard storageIsAvailable, !fallbackQueue.isEmpty else { return }
        let queued = fallbackQueue.sorted {
            if $0.priorityRank != $1.priorityRank { return $0.priorityRank > $1.priorityRank }
            return $0.createdAt < $1.createdAt
        }
        fallbackQueue.removeAll()
        persistFallback(queued, at: 0)
    }

    private func persistFallback(_ records: [ErrorReportRecord], at index: Int) {
        guard index < records.count else {
            if records.contains(where: {
                $0.priorty.diagnosticRank >= TCFundamentals.ErrorReportingPriorty.high.diagnosticRank
            }) {
                flushPendingReports(reason: .immediate)
            }
            return
        }
        store.save(records[index]) { result in
            if case .failure = result {
                self.storageIsAvailable = false
                for remaining in records[index...] {
                    self.addToFallback(remaining)
                }
                return
            }
            self.persistFallback(records, at: index + 1)
        }
    }

    private func deliver(_ records: [ErrorReportRecord], at index: Int, completion: @escaping () -> Void) {
        guard index < records.count else {
            completion()
            return
        }

        let record = records[index]
        API.v1.reportError(record: record) { result in
            let now = getNow()
            switch result {
            case .success:
                var completedRecord = record
                completedRecord.reported = true
                completedRecord.reportedAt = now
                completedRecord.lastAttemptAt = now
                completedRecord.nextRetryAt = nil
                completedRecord.lastReportingError = nil
                completedRecord.inFlightUntil = nil
                self.store.saveCompleted(completedRecord) { result in
                    if case .failure = result {
                        self.storageIsAvailable = false
                    }
                    self.deliver(records, at: index + 1, completion: completion)
                }
            case .failure(let message, let retryAfter):
                let nextRetry = max(now + self.retryInterval, retryAfter ?? 0)
                let safeReportingError = self.truncate(
                    self.redactSensitiveValues(message),
                    limit: 16 * 1024
                ).value
                self.store.recordFailure(
                    id: record.id,
                    attemptedAt: now,
                    nextRetryAt: nextRetry,
                    error: safeReportingError
                ) {
                    self.deliver(records, at: index + 1, completion: completion)
                }
            }
        }
    }

    private func scheduleNextFlush() {
        scheduledFlushGeneration += 1
        let generation = scheduledFlushGeneration
        Web.Dispatch.asyncAfter(Double(retryInterval)) {
            guard self.hasStarted, generation == self.scheduledFlushGeneration else { return }
            self.flushPendingReports(reason: .scheduled)
            self.scheduleNextFlush()
        }
    }

    private func resolvedPriorty(
        for category: ErrorReportType,
        requested: TCFundamentals.ErrorReportingPriorty,
        httpStatus: Int?
    ) -> TCFundamentals.ErrorReportingPriorty {
        var derived: TCFundamentals.ErrorReportingPriorty
        switch category {
        case .requestEncoding, .decoding, .unexpected:
            derived = .high
        case .network, .timeout, .http, .emptyResponse, .api:
            derived = .med
        case .aborted:
            derived = .low
        }

        if let status = httpStatus {
            if status == 401 || status == 403 || (500...599).contains(status) {
                derived = .high
            }
        }
        return requested.raised(to: derived)
    }

    private func fallbackContext(
        priorty: TCFundamentals.ErrorReportingPriorty,
        file: String,
        line: Int,
        function: String
    ) -> HTTPRequestDiagnosticContext {
        HTTPRequestDiagnosticContext(
            endpoint: function,
            requestURL: "",
            route: nil,
            version: nil,
            service: nil,
            priorty: priorty,
            sourceFile: file,
            sourceLine: line,
            sourceFunction: function,
            requestPayload: nil,
            createdAt: getNow(),
            username: custCatchUser,
            accountId: custCatchUser.isEmpty ? nil : custCatchID,
            tokenReference: errorReportingTokenReference(custCatchToken)
        )
    }

    private func makeRecord(
        category: ErrorReportType,
        priorty: TCFundamentals.ErrorReportingPriorty,
        context: HTTPRequestDiagnosticContext,
        title: String,
        error: String,
        responsePayload: String?,
        httpStatus: Int?,
        httpStatusText: String?
    ) -> ErrorReportRecord {
        let now = getNow()
        let request = sanitizePayload(context.requestPayload, limit: 32 * 1024)
        let response = sanitizePayload(responsePayload, limit: 64 * 1024)
        let sourceFile = sanitizeSourceFile(context.sourceFile)
        let endpoint = sanitizeURL(context.endpoint)
        let requestURL = sanitizeURL(context.requestURL)
        let safeTitle = truncate(redactSensitiveValues(title), limit: 4 * 1024).value
        let safeError = truncate(redactSensitiveValues(error), limit: 16 * 1024).value
        let safeStatusText = httpStatusText.map { truncate(redactSensitiveValues($0), limit: 2 * 1024).value }
        let fingerprintSource = [
            category.rawValue,
            priorty.rawValue,
            endpoint,
            httpStatus.map(String.init) ?? "",
            safeTitle,
            sourceFile,
            String(context.sourceLine)
        ].joined(separator: "|")

        return ErrorReportRecord(
            id: UUID(),
            schemaVersion: 1,
            createdAt: now,
            expiresAt: now + retentionInterval,
            lastOccurredAt: now,
            type: "web",
            category: category,
            priorty: priorty,
            priorityRank: priorty.diagnosticRank,
            token: context.tokenReference,
            username: context.username,
            accountId: context.accountId,
            device: truncate(WebApp.current.window.navigator.userAgent, limit: 2 * 1024).value,
            hostname: WebApp.shared.window.location.hostname,
            pathname: sanitizeURL(WebApp.shared.window.location.pathname),
            appName: applicationName,
            appVersion: SkylineWeb().version.description,
            environment: developmentMode.rawValue,
            errorTitle: safeTitle,
            error: safeError,
            requestId: context.requestId,
            method: context.method,
            endpoint: endpoint,
            requestURL: requestURL,
            route: context.route,
            version: context.version,
            service: context.service,
            requestPayload: request.value,
            responsePayload: response.value,
            httpStatus: httpStatus,
            httpStatusText: safeStatusText,
            sourceFile: sourceFile,
            sourceLine: context.sourceLine,
            sourceFunction: context.sourceFunction,
            payloadWasTruncated: request.wasTruncated,
            responseWasTruncated: response.wasTruncated,
            fingerprint: stableErrorReportingFingerprint(fingerprintSource),
            occurrenceCount: 1,
            retries: 0,
            lastAttemptAt: nil,
            nextRetryAt: nil,
            lastReportingError: nil,
            reported: false,
            reportedAt: nil,
            inFlightUntil: nil
        )
    }

    private func sanitizePayload(_ payload: String?, limit: Int) -> (value: String?, wasTruncated: Bool) {
        guard let payload, !payload.isEmpty else { return (nil, false) }
        guard let data = payload.data(using: .utf8) else {
            return ("[non-UTF8 payload omitted]", false)
        }

        do {
            let object = try JSONSerialization.jsonObject(with: data, options: [.fragmentsAllowed])
            let redacted = redactJSON(object)
            let safeData = try JSONSerialization.data(withJSONObject: redacted, options: [])
            let safeString = String(data: safeData, encoding: .utf8) ?? "[payload serialization failed]"
            return truncate(safeString, limit: limit)
        } catch {
            return ("[non-JSON payload omitted; \(data.count) bytes]", false)
        }
    }

    private func redactJSON(_ value: Any) -> Any {
        if let dictionary = value as? [String: Any] {
            var result: [String: Any] = [:]
            for (key, value) in dictionary {
                if isSensitiveKey(key) {
                    result[key] = "<redacted>"
                } else if isLargeContentKey(key), let string = value as? String, string.utf8.count > 4 * 1024 {
                    result[key] = "<large content omitted>"
                } else {
                    result[key] = redactJSON(value)
                }
            }
            return result
        }
        if let array = value as? [Any] {
            return array.map(redactJSON)
        }
        if let string = value as? String {
            if string.count > 8 * 1024 && looksLikeEncodedFile(string) {
                return "<large encoded value omitted>"
            }
            return redactSensitiveValues(string)
        }
        return value
    }

    private func isSensitiveKey(_ key: String) -> Bool {
        let normalized = key.lowercased().replacingOccurrences(of: "_", with: "")
        let exact = ["authorization", "password", "pass", "secret", "key", "herk", "pin", "cvv", "cookie", "session", "signature"]
        if exact.contains(normalized) { return true }
        return ["token", "jwt", "cardnumber", "privatekey", "accesstoken", "refreshtoken"].contains {
            normalized.contains($0)
        }
    }

    private func looksLikeEncodedFile(_ value: String) -> Bool {
        if value.hasPrefix("data:") { return true }
        let sample = value.prefix(512)
        guard !sample.isEmpty else { return false }
        let encodedCharacters = sample.filter {
            $0.isLetter || $0.isNumber || "+/=_-".contains($0)
        }.count
        return Double(encodedCharacters) / Double(sample.count) > 0.95
    }

    private func isLargeContentKey(_ key: String) -> Bool {
        let normalized = key.lowercased().replacingOccurrences(of: "_", with: "")
        return ["file", "filecontent", "image", "document", "base64", "xml", "html", "attachment"].contains(normalized)
    }

    private func sanitizeURL(_ value: String) -> String {
        guard let question = value.firstIndex(of: "?") else { return value }
        let base = String(value[..<question])
        let queryAndFragment = String(value[value.index(after: question)...])
        let pieces = queryAndFragment.split(separator: "&", omittingEmptySubsequences: false).map { piece -> String in
            let pair = piece.split(separator: "=", maxSplits: 1, omittingEmptySubsequences: false)
            guard let key = pair.first else { return String(piece) }
            if isSensitiveKey(String(key)) {
                return "\(key)=<redacted>"
            }
            return String(piece)
        }
        return base + "?" + pieces.joined(separator: "&")
    }

    private func sanitizeSourceFile(_ value: String) -> String {
        let parts = value.split(separator: "/")
        return parts.suffix(2).joined(separator: "/")
    }

    private func redactSensitiveValues(_ value: String) -> String {
        var result = value
        for secret in [custCatchToken, custCatchKey, custCatchMid, thisAppToken] where !secret.isEmpty {
            result = result.replacingOccurrences(of: secret, with: "<redacted>")
        }
        return result
    }

    private func truncate(_ value: String, limit: Int) -> (value: String, wasTruncated: Bool) {
        let bytes = Array(value.utf8)
        guard bytes.count > limit else { return (value, false) }
        let headCount = limit * 2 / 3
        let tailCount = limit - headCount
        let head = String(decoding: bytes.prefix(headCount), as: UTF8.self)
        let tail = String(decoding: bytes.suffix(tailCount), as: UTF8.self)
        return (head + "\n…<truncated>…\n" + tail, true)
    }
}

func stableErrorReportingFingerprint(_ value: String) -> String {
    stableErrorReportingFingerprint(Foundation.Data(value.utf8))
}

func errorReportingTokenReference(_ token: String) -> String {
    token.isEmpty ? "" : "<redacted-token:\(token.utf8.count)-bytes>"
}

func stableErrorReportingFingerprint(_ value: Foundation.Data) -> String {
    var hash: UInt64 = 14_695_981_039_346_656_037
    for byte in value {
        hash ^= UInt64(byte)
        hash = hash &* 1_099_511_628_211
    }
    return String(hash, radix: 16)
}
