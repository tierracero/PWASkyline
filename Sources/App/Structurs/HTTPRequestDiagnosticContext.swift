import Foundation
import TCFundamentals

public struct HTTPRequestDiagnosticContext: Codable {
    public let requestId: UUID
    public let method: String
    public let endpoint: String
    public let requestURL: String
    public let route: String?
    public let version: String?
    public let service: String?
    public let priorty: TCFundamentals.ErrorReportingPriorty
    public let sourceFile: String
    public let sourceLine: Int
    public let sourceFunction: String
    public let requestPayload: String?
    public let createdAt: Int64
    public let username: String
    public let accountId: UUID?
    public let tokenReference: String

    public init(
        requestId: UUID = UUID(),
        method: String = "POST",
        endpoint: String,
        requestURL: String,
        route: String?,
        version: String?,
        service: String?,
        priorty: TCFundamentals.ErrorReportingPriorty,
        sourceFile: String,
        sourceLine: Int,
        sourceFunction: String,
        requestPayload: String?,
        createdAt: Int64,
        username: String,
        accountId: UUID?,
        tokenReference: String
    ) {
        self.requestId = requestId
        self.method = method
        self.endpoint = endpoint
        self.requestURL = requestURL
        self.route = route
        self.version = version
        self.service = service
        self.priorty = priorty
        self.sourceFile = sourceFile
        self.sourceLine = sourceLine
        self.sourceFunction = sourceFunction
        self.requestPayload = requestPayload
        self.createdAt = createdAt
        self.username = username
        self.accountId = accountId
        self.tokenReference = tokenReference
    }
}
