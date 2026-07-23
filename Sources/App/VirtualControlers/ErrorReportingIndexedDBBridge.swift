import Foundation
import JavaScriptKit

enum ErrorReportingStoreError: Error, CustomStringConvertible {
    case unavailable
    case encoding(String)
    case bridge(String)
    case decoding(String)

    var description: String {
        switch self {
        case .unavailable:
            return "IndexedDB bridge is unavailable"
        case .encoding(let message), .bridge(let message), .decoding(let message):
            return message
        }
    }
}

final class ErrorReportingIndexedDBBridge {
    static let shared = ErrorReportingIndexedDBBridge()

    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    private init() {}

    func open(completion: @escaping (Result<Void, ErrorReportingStoreError>) -> Void) {
        invoke("open", arguments: []) { result in
            completion(result.map { _ in () })
        }
    }

    func save(
        _ record: ErrorReportRecord,
        completion: @escaping (Result<ErrorReportRecord, ErrorReportingStoreError>) -> Void
    ) {
        guard let payload = encode(record) else {
            completion(.failure(.encoding("Unable to encode error report for IndexedDB")))
            return
        }
        invoke("save", arguments: [payload]) { [decoder] result in
            completion(result.flatMap { Self.decode(ErrorReportRecord.self, from: $0, using: decoder) })
        }
    }

    func saveCompleted(
        _ record: ErrorReportRecord,
        completion: @escaping (Result<ErrorReportRecord, ErrorReportingStoreError>) -> Void
    ) {
        guard let payload = encode(record) else {
            completion(.failure(.encoding("Unable to encode completed error report for IndexedDB")))
            return
        }
        invoke("saveCompleted", arguments: [payload]) { [decoder] result in
            completion(result.flatMap { Self.decode(ErrorReportRecord.self, from: $0, using: decoder) })
        }
    }

    func getRecords(
        completion: @escaping (Result<[ErrorReportRecord], ErrorReportingStoreError>) -> Void
    ) {
        invoke("getRecords", arguments: []) { [decoder] result in
            completion(result.flatMap { Self.decode([ErrorReportRecord].self, from: $0, using: decoder) })
        }
    }

    func claimPending(
        username: String,
        accountId: UUID?,
        now: Int64,
        limit: Int,
        leaseUntil: Int64,
        completion: @escaping (Result<[ErrorReportRecord], ErrorReportingStoreError>) -> Void
    ) {
        invoke(
            "claimPending",
            arguments: [username, accountId?.uuidString ?? "", Double(now), limit, Double(leaseUntil)]
        ) { [decoder] result in
            completion(result.flatMap { Self.decode([ErrorReportRecord].self, from: $0, using: decoder) })
        }
    }

    func recordFailure(
        id: UUID,
        attemptedAt: Int64,
        nextRetryAt: Int64,
        error: String,
        completion: @escaping () -> Void
    ) {
        invoke(
            "recordFailure",
            arguments: [id.uuidString, Double(attemptedAt), Double(nextRetryAt), error]
        ) { _ in completion() }
    }

    func releaseClaim(id: UUID, completion: @escaping () -> Void = {}) {
        invoke("releaseClaim", arguments: [id.uuidString]) { _ in completion() }
    }

    func deleteExpired(now: Int64, completion: @escaping () -> Void = {}) {
        invoke("deleteExpired", arguments: [Double(now)]) { _ in completion() }
    }

    private func encode<T: Encodable>(_ value: T) -> String? {
        guard let data = try? encoder.encode(value) else { return nil }
        return String(data: data, encoding: .utf8)
    }

    private static func decode<T: Decodable>(
        _ type: T.Type,
        from string: String,
        using decoder: JSONDecoder
    ) -> Result<T, ErrorReportingStoreError> {
        guard let data = string.data(using: .utf8) else {
            return .failure(.decoding("IndexedDB bridge returned non-UTF8 data"))
        }
        do {
            return .success(try decoder.decode(type, from: data))
        } catch {
            return .failure(.decoding("Unable to decode IndexedDB response: \(error)"))
        }
    }

    private func invoke(
        _ method: String,
        arguments: [ConvertibleToJSValue],
        completion: @escaping (Result<String, ErrorReportingStoreError>) -> Void
    ) {
        guard
            let store = JSObject.global.PWASkylineErrorStore.object,
            let function = store[method].function
        else {
            completion(.failure(.unavailable))
            return
        }

        let callback = JSOneshotClosure { values in
            if values.count > 1, let message = values[1].string, !message.isEmpty {
                completion(.failure(.bridge(message)))
            } else {
                completion(.success(values.first?.string ?? ""))
            }
            return .undefined
        }

        var callArguments = arguments
        callArguments.append(callback)
        function(this: store, arguments: callArguments)
    }
}
