import Foundation
import TCFundamentals

final class HTTPRequestDiagnosticRegistry {
    static let shared = HTTPRequestDiagnosticRegistry()

    private struct Entry {
        let context: HTTPRequestDiagnosticContext
        let registeredAt: Int64
    }

    private var entries: [String: [Entry]] = [:]
    private let maximumEntries = 100

    private init() {}

    func register(data: Foundation.Data, context: HTTPRequestDiagnosticContext) {
        prune()
        let key = stableErrorReportingFingerprint(data)
        entries[key, default: []].append(.init(context: context, registeredAt: getNow()))

        while entries.values.reduce(0, { $0 + $1.count }) > maximumEntries {
            guard let oldestKey = entries.min(by: {
                ($0.value.first?.registeredAt ?? .max) < ($1.value.first?.registeredAt ?? .max)
            })?.key else { break }
            entries[oldestKey]?.removeFirst()
            if entries[oldestKey]?.isEmpty == true {
                entries[oldestKey] = nil
            }
        }
    }

    func take(data: Foundation.Data) -> HTTPRequestDiagnosticContext? {
        let key = stableErrorReportingFingerprint(data)
        guard var values = entries[key], !values.isEmpty else { return nil }
        let context = values.removeFirst().context
        entries[key] = values.isEmpty ? nil : values
        return context
    }

    private func prune() {
        let cutoff = getNow() - 300
        for key in Array(entries.keys) {
            entries[key] = entries[key]?.filter { $0.registeredAt >= cutoff }
            if entries[key]?.isEmpty == true {
                entries[key] = nil
            }
        }
    }
}

@discardableResult
public func decodeAPIResponse<Response: Decodable>(
    _ responseType: Response.Type,
    from data: Foundation.Data,
    priorty: TCFundamentals.ErrorReportingPriorty = .high,
    file: String = #fileID,
    line: Int = #line,
    function: String = #function
) throws -> Response {
    let context = HTTPRequestDiagnosticRegistry.shared.take(data: data)

    do {
        let response = try Foundation.JSONDecoder().decode(responseType, from: data)
        if apiResponseStatus(from: response) == "kill" {
            ErrorReportingControler.shared.reportAPIError(
                priorty: TCFundamentals.ErrorReportingPriorty.high.raised(to: priorty),
                responseType: String(reflecting: responseType),
                responseData: data,
                context: context,
                file: file,
                line: line,
                function: function
            )
        }
        return response
    } catch {
        ErrorReportingControler.shared.reportDecodingError(
            priorty: priorty,
            responseType: String(reflecting: responseType),
            error: error,
            responseData: data,
            context: context,
            file: file,
            line: line,
            function: function
        )
        throw error
    }
}

private func apiResponseStatus<Response>(from response: Response) -> String? {
    for child in Mirror(reflecting: response).children where child.label == "status" {
        return String(describing: child.value).lowercased()
    }
    return nil
}

func errorReportingDecodingDescription(_ error: Error) -> String {
    func path(_ codingPath: [CodingKey]) -> String {
        let value = codingPath.map { $0.stringValue }.joined(separator: ".")
        return value.isEmpty ? "<root>" : value
    }

    switch error {
    case DecodingError.typeMismatch(let type, let context):
        return "typeMismatch(\(type)) at \(path(context.codingPath)): \(context.debugDescription)"
    case DecodingError.valueNotFound(let type, let context):
        return "valueNotFound(\(type)) at \(path(context.codingPath)): \(context.debugDescription)"
    case DecodingError.keyNotFound(let key, let context):
        return "keyNotFound(\(key.stringValue)) at \(path(context.codingPath)): \(context.debugDescription)"
    case DecodingError.dataCorrupted(let context):
        return "dataCorrupted at \(path(context.codingPath)): \(context.debugDescription)"
    default:
        return String(describing: error)
    }
}
