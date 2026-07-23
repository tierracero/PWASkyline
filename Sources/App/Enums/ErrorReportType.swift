import Foundation

public enum ErrorReportType: String, Codable {
    case requestEncoding
    case network
    case timeout
    case aborted
    case http
    case emptyResponse
    case decoding
    case api
    case unexpected
}
