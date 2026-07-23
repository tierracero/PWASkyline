//
//  API+ReportError.swift
//
//  Created by Victor Cantu on 10/19/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

enum ErrorReportDeliveryResult {
    case success
    case failure(message: String, retryAfter: Int64?)
}

extension APIComponents {

    static func reportError(
        record: ErrorReportRecord,
        callback: @escaping (ErrorReportDeliveryResult) -> Void
    ) {
        let diagnosticJSON: String
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.sortedKeys]
            diagnosticJSON = String(decoding: try encoder.encode(record), as: UTF8.self)
        } catch {
            callback(.failure(
                message: "Unable to encode the persisted diagnostic record: \(error)",
                retryAfter: nil
            ))
            return
        }

        sendPostForErrorReporting(
            rout,
            version,
            "reportError",
            ReportErrorRequest(
                appid: nil,
                type: record.type,
                token: custCatchToken,
                username: record.username,
                device: record.device,
                priorty: record.priorty,
                errorTitle: record.errorTitle,
                error: diagnosticJSON
            )
        ) { transport in
            guard let transport else {
                callback(.failure(message: "The reporting request could not be encoded or sent.", retryAfter: nil))
                return
            }

            guard (200...299).contains(transport.status) else {
                callback(.failure(
                    message: "Reporting endpoint returned HTTP \(transport.status) \(transport.statusText)",
                    retryAfter: transport.retryAfter
                ))
                return
            }

            guard let data = transport.data, !data.isEmpty else {
                callback(.failure(message: "Reporting endpoint returned an empty response.", retryAfter: nil))
                return
            }

            do {
                let decoder = Foundation.JSONDecoder()
                let response = try decoder.decode(APIResponse.self, from: data)
                guard response.status == .ok else {
                    callback(.failure(
                        message: "Reporting endpoint rejected the diagnostic: \(response.msg)",
                        retryAfter: transport.retryAfter
                    ))
                    return
                }
                callback(.success)
            } catch {
                callback(.failure(
                    message: "Reporting endpoint response decoding failed: \(error)",
                    retryAfter: transport.retryAfter
                ))
            }
        }
    }
}
