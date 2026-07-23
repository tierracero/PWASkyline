//
//  sendPost.swift
//
//  Created by Victor Cantu on 2/16/22.
//

import Foundation
import TCFundamentals
import TCFireSignal
import XMLHttpRequest
import Web

enum ErrorReportingPolicy: Equatable {
    case automatic
    case disabled
}

struct HTTPTransportResult {
    let data: Foundation.Data?
    let status: Int
    let statusText: String
    let retryAfter: Int64?
}

private enum HTTPAuthorization {
    case explicit(String)
    case apiHeader
    case none
}

private struct HTTPRequestConfiguration {
    let url: String
    let route: String?
    let version: String?
    let service: String?
    let authorization: HTTPAuthorization
    let priorty: TCFundamentals.ErrorReportingPriorty
    let errorReportingPolicy: ErrorReportingPolicy
    let expectsResponseBody: Bool
    let timeoutMilliseconds: Double
    let file: String
    let line: Int
    let function: String
}

private final class HTTPCompletionGate {
    private var hasCompleted = false
    private let callback: (HTTPTransportResult?) -> Void

    init(callback: @escaping (HTTPTransportResult?) -> Void) {
        self.callback = callback
    }

    func complete(
        _ result: HTTPTransportResult?,
        beforeCallback: () -> Void = {},
        afterCallback: () -> Void = {}
    ) {
        guard !hasCompleted else { return }
        hasCompleted = true
        beforeCallback()
        callback(result)
        afterCallback()
    }
}

public func sendPost<T: Codable>(
    _ route: ServerRouts,
    _ version: ServerVersion?,
    _ service: String,
    _ auth: String,
    _ codable: T,
    _ priorty: TCFundamentals.ErrorReportingPriorty = .med,
    _ file: String = #fileID,
    _ line: Int = #line,
    _ function: String = #function,
    callback: @escaping ((_ payload: Foundation.Data?) -> Void)
) {
    let url = explicitAuthorizationURL(route: route, version: version, service: service)
    sendPostInternal(
        HTTPRequestConfiguration(
            url: url,
            route: route.rawValue,
            version: version?.rawValue,
            service: service,
            authorization: .explicit(auth),
            priorty: priorty,
            errorReportingPolicy: .automatic,
            expectsResponseBody: true,
            timeoutMilliseconds: 120_000,
            file: file,
            line: line,
            function: function
        ),
        codable
    ) { result in
        callback(result?.data)
    }
}

public func sendPost<T: Codable>(
    _ route: ServerRouts,
    _ version: ServerVersion?,
    _ service: String,
    _ codable: T,
    _ priorty: TCFundamentals.ErrorReportingPriorty = .med,
    _ file: String = #fileID,
    _ line: Int = #line,
    _ function: String = #function,
    callback: @escaping ((_ payload: Foundation.Data?) -> Void)
) {
    sendAuthenticatedPost(
        route,
        version,
        service,
        codable,
        priorty: priorty,
        policy: .automatic,
        file: file,
        line: line,
        function: function
    ) { result in
        callback(result?.data)
    }
}

public func sendPost<T: Codable>(
    _ url: String,
    _ codable: T,
    _ priorty: TCFundamentals.ErrorReportingPriorty = .med,
    _ file: String = #fileID,
    _ line: Int = #line,
    _ function: String = #function,
    callback: @escaping ((_ payload: Foundation.Data?) -> Void)
) {
    sendPostInternal(
        HTTPRequestConfiguration(
            url: url,
            route: nil,
            version: nil,
            service: nil,
            authorization: .apiHeader,
            priorty: priorty,
            errorReportingPolicy: .automatic,
            expectsResponseBody: true,
            timeoutMilliseconds: 120_000,
            file: file,
            line: line,
            function: function
        ),
        codable
    ) { result in
        callback(result?.data)
    }
}

func sendPostForErrorReporting<T: Codable>(
    _ route: ServerRouts,
    _ version: ServerVersion?,
    _ service: String,
    _ codable: T,
    callback: @escaping (HTTPTransportResult?) -> Void
) {
    sendAuthenticatedPost(
        route,
        version,
        service,
        codable,
        priorty: .low,
        policy: .disabled,
        file: #fileID,
        line: #line,
        function: #function,
        callback: callback
    )
}

private func sendAuthenticatedPost<T: Codable>(
    _ route: ServerRouts,
    _ version: ServerVersion?,
    _ service: String,
    _ codable: T,
    priorty: TCFundamentals.ErrorReportingPriorty,
    policy: ErrorReportingPolicy,
    file: String,
    line: Int,
    function: String,
    callback: @escaping (HTTPTransportResult?) -> Void
) {
    let url = authenticatedURL(route: route, version: version, service: service)
    sendPostInternal(
        HTTPRequestConfiguration(
            url: url,
            route: route.rawValue,
            version: version?.rawValue,
            service: service,
            authorization: .apiHeader,
            priorty: priorty,
            errorReportingPolicy: policy,
            expectsResponseBody: true,
            timeoutMilliseconds: 120_000,
            file: file,
            line: line,
            function: function
        ),
        codable,
        callback: callback
    )
}

private func sendPostInternal<T: Codable>(
    _ configuration: HTTPRequestConfiguration,
    _ codable: T,
    callback: @escaping (HTTPTransportResult?) -> Void
) {
    let gate = HTTPCompletionGate(callback: callback)
    let payload: String

    do {
        let data = try JSONEncoder().encode(codable)
        guard let string = String(data: data, encoding: .utf8) else {
            throw EncodingError.invalidValue(
                codable,
                .init(codingPath: [], debugDescription: "Encoded request is not valid UTF-8")
            )
        }
        payload = string
    } catch {
        let context = diagnosticContext(configuration: configuration, requestPayload: nil)
        gate.complete(nil, afterCallback: {
            reportIfEnabled(
                configuration,
                category: .requestEncoding,
                context: context,
                title: "Request encoding failed",
                error: "Unable to encode \(String(reflecting: T.self)): \(error)"
            )
        })
        return
    }

    let context = diagnosticContext(configuration: configuration, requestPayload: payload)
    let authorization: String?
    do {
        authorization = try authorizationHeader(configuration.authorization)
    } catch {
        gate.complete(nil, afterCallback: {
            reportIfEnabled(
                configuration,
                category: .requestEncoding,
                context: context,
                title: "Authorization header encoding failed",
                error: String(describing: error)
            )
        })
        return
    }

    let xhr = XMLHttpRequest()
    xhr.open(method: "POST", url: configuration.url)
    xhr.jsValue.timeout = configuration.timeoutMilliseconds.jsValue
    xhr.setRequestHeader("Accept", "application/json")
        .setRequestHeader("Content-Type", "application/json")
        .setRequestHeader("AppName", applicationName)
        .setRequestHeader("AppVersion", SkylineWeb().version.description)

    if let authorization, !authorization.isEmpty {
        xhr.setRequestHeader("Authorization", authorization)
    }

    xhr.onError {
        gate.complete(HTTPTransportResult(
            data: nil,
            status: xhr.status,
            statusText: xhr.statusText,
            retryAfter: retryAfterTimestamp(from: xhr)
        ), afterCallback: {
            reportIfEnabled(
                configuration,
                category: .network,
                context: context,
                title: "Network request failed",
                error: "XMLHttpRequest emitted an error event.",
                responsePayload: xhr.responseText,
                httpStatus: normalizedStatus(xhr.status),
                httpStatusText: xhr.statusText
            )
        })
    }

    xhr.onTimeout {
        gate.complete(HTTPTransportResult(
            data: nil,
            status: xhr.status,
            statusText: xhr.statusText,
            retryAfter: retryAfterTimestamp(from: xhr)
        ), afterCallback: {
            reportIfEnabled(
                configuration,
                category: .timeout,
                context: context,
                title: "Network request timed out",
                error: "The request exceeded \(Int(configuration.timeoutMilliseconds / 1_000)) seconds.",
                responsePayload: xhr.responseText,
                httpStatus: normalizedStatus(xhr.status),
                httpStatusText: xhr.statusText
            )
        })
    }

    xhr.onAbort {
        gate.complete(HTTPTransportResult(
            data: nil,
            status: xhr.status,
            statusText: xhr.statusText,
            retryAfter: retryAfterTimestamp(from: xhr)
        ), afterCallback: {
            reportIfEnabled(
                configuration,
                category: .aborted,
                context: context,
                title: "Network request was aborted",
                error: "XMLHttpRequest emitted an abort event.",
                responsePayload: xhr.responseText,
                httpStatus: normalizedStatus(xhr.status),
                httpStatusText: xhr.statusText
            )
        })
    }

    xhr.onLoad {
        let responseText = xhr.responseText
        let responseData = responseText?.data(using: .utf8)
        let statusIsSuccessful = (200...299).contains(xhr.status)

        gate.complete(HTTPTransportResult(
            data: responseData,
            status: xhr.status,
            statusText: xhr.statusText,
            retryAfter: retryAfterTimestamp(from: xhr)
        ), beforeCallback: {
            if configuration.errorReportingPolicy == .automatic, let responseData {
                HTTPRequestDiagnosticRegistry.shared.register(data: responseData, context: context)
            }
        }, afterCallback: {
            if !statusIsSuccessful {
                reportIfEnabled(
                    configuration,
                    category: .http,
                    context: context,
                    title: "HTTP request returned status \(xhr.status)",
                    error: xhr.statusText.isEmpty ? "Non-successful HTTP status" : xhr.statusText,
                    responsePayload: responseText,
                    httpStatus: normalizedStatus(xhr.status),
                    httpStatusText: xhr.statusText
                )
            } else if configuration.expectsResponseBody && (responseText?.isEmpty != false) {
                reportIfEnabled(
                    configuration,
                    category: .emptyResponse,
                    context: context,
                    title: "HTTP request returned an empty response",
                    error: "A response body was expected for a successful request.",
                    httpStatus: xhr.status,
                    httpStatusText: xhr.statusText
                )
            }
        })
    }

    xhr.send(payload)
}

private func diagnosticContext(
    configuration: HTTPRequestConfiguration,
    requestPayload: String?
) -> HTTPRequestDiagnosticContext {
    HTTPRequestDiagnosticContext(
        endpoint: configuration.url,
        requestURL: configuration.url,
        route: configuration.route,
        version: configuration.version,
        service: configuration.service,
        priorty: configuration.priorty,
        sourceFile: configuration.file,
        sourceLine: configuration.line,
        sourceFunction: configuration.function,
        requestPayload: requestPayload,
        createdAt: getNow(),
        username: custCatchUser,
        accountId: custCatchUser.isEmpty ? nil : custCatchID,
        tokenReference: errorReportingTokenReference(custCatchToken)
    )
}

private func reportIfEnabled(
    _ configuration: HTTPRequestConfiguration,
    category: ErrorReportType,
    context: HTTPRequestDiagnosticContext,
    title: String,
    error: String,
    responsePayload: String? = nil,
    httpStatus: Int? = nil,
    httpStatusText: String? = nil
) {
    guard configuration.errorReportingPolicy == .automatic else { return }
    ErrorReportingControler.shared.reportTransportError(
        category: category,
        priorty: configuration.priorty,
        context: context,
        title: title,
        error: error,
        responsePayload: responsePayload,
        httpStatus: httpStatus,
        httpStatusText: httpStatusText
    )
}

private func authorizationHeader(_ authorization: HTTPAuthorization) throws -> String? {
    switch authorization {
    case .explicit(let value):
        return value
    case .none:
        return nil
    case .apiHeader:
        let data = try JSONEncoder().encode(APIHeader(
            AppID: thisAppID,
            AppToken: thisAppToken,
            url: custCatchUrl,
            user: custCatchUser,
            mid: custCatchMid,
            key: custCatchKey,
            token: custCatchToken,
            tcon: .web,
            applicationType: custCatchAccountType.sessionType
        ))
        guard let value = String(data: data, encoding: .utf8) else {
            throw EncodingError.invalidValue(
                APIHeader.self,
                .init(codingPath: [], debugDescription: "Authorization header is not valid UTF-8")
            )
        }
        return Foundation.Data(value.utf8).base64EncodedString()
    }
}

private func explicitAuthorizationURL(
    route: ServerRouts,
    version: ServerVersion?,
    service: String
) -> String {
    var server = "https://api.tierracero.co"
    if WebApp.shared.window.location.hostname == "localhost" || WebApp.shared.window.location.hostname == localTestIp {
        switch developmentMode {
        case .local:
            server = "http://localhost:8800/api"
        case .develpment:
            server = "http://dev.tierracero.co/api"
        case .produccion:
            break
        }
    }
    return requestURL(server: server, route: route, version: version, service: service)
}

private func authenticatedURL(
    route: ServerRouts,
    version: ServerVersion?,
    service: String
) -> String {
    var server = "https://api.tierracero.co"
    switch developmentMode {
    case .local:
        server = "https://localhost:8800/api"
    case .develpment:
        server = "https://dev.tierracero.co/api"
    case .produccion:
        break
    }
    return requestURL(server: server, route: route, version: version, service: service)
}

private func requestURL(
    server: String,
    route: ServerRouts,
    version: ServerVersion?,
    service: String
) -> String {
    var url = "\(server)/\(route.rawValue)"
    if let version {
        url += version.rawValue
    }
    if !service.isEmpty {
        url += "/\(service)"
    }
    return url
}

private func normalizedStatus(_ status: Int) -> Int? {
    status > 0 ? status : nil
}

private func retryAfterTimestamp(from xhr: XMLHttpRequest) -> Int64? {
    guard
        let value = exposedResponseHeader(
            named: "Retry-After",
            in: xhr.getAllResponseHeaders()
        ),
        let seconds = Int64(value.trimmingCharacters(in: .whitespacesAndNewlines)),
        seconds > 0
    else {
        return nil
    }
    return getNow() + seconds
}

private func exposedResponseHeader(named name: String, in headers: String) -> String? {
    for line in headers.split(whereSeparator: { $0.isNewline }) {
        let components = line.split(separator: ":", maxSplits: 1, omittingEmptySubsequences: false)
        guard components.count == 2 else { continue }
        guard String(components[0]).trimmingCharacters(in: .whitespacesAndNewlines)
            .caseInsensitiveCompare(name) == .orderedSame
        else {
            continue
        }
        return String(components[1]).trimmingCharacters(in: .whitespacesAndNewlines)
    }
    return nil
}
