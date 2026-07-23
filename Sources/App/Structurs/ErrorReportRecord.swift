import Foundation
import TCFundamentals

public struct ErrorReportRecord: Codable, Hashable {
    public let id: UUID
    public let schemaVersion: Int
    public let createdAt: Int64
    public let expiresAt: Int64
    public var lastOccurredAt: Int64

    public let type: String
    public let category: ErrorReportType
    public let priorty: TCFundamentals.ErrorReportingPriorty
    public let priorityRank: Int

    public let token: String
    public let username: String
    public let accountId: UUID?
    public let device: String
    public let hostname: String
    public let pathname: String
    public let appName: String
    public let appVersion: String
    public let environment: String

    public let errorTitle: String
    public let error: String
    public let requestId: UUID
    public let method: String
    public let endpoint: String
    public let requestURL: String
    public let route: String?
    public let version: String?
    public let service: String?
    public let requestPayload: String?
    public let responsePayload: String?
    public let httpStatus: Int?
    public let httpStatusText: String?
    public let sourceFile: String
    public let sourceLine: Int
    public let sourceFunction: String
    public let payloadWasTruncated: Bool
    public let responseWasTruncated: Bool

    public let fingerprint: String
    public var occurrenceCount: Int
    public var retries: Int
    public var lastAttemptAt: Int64?
    public var nextRetryAt: Int64?
    public var lastReportingError: String?
    public var reported: Bool
    public var reportedAt: Int64?
    public var inFlightUntil: Int64?
}
