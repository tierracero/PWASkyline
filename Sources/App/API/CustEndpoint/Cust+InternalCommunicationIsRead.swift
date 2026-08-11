//
//  Cust+InternalCommunicationIsRead.swift
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustComponents {

    static func internalCommunicationIsRead(
        communicationId: UUID,
        callback: @escaping ((_ resp: APIResponse?) -> ())
    ) {
        sendPost(
            rout,
            version,
            "internalCommunicationIsRead",
            InternalCommunicationIsReadRequest(
                communicationId: communicationId
            )
        ) { data in
            guard let data else {
                callback(nil)
                return
            }

            do {
                callback(try decodeAPIResponse(APIResponse.self, from: data))
            } catch {
                print("🔴 API_DECODING_ERROR")
                print(error)
                callback(nil)
            }
        }
    }
}
