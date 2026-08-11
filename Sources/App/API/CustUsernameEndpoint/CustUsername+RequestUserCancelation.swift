//
//  CustUsername+RequestUserCancelation.swift
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustUsernameComponents {

    static func requestUserCancelation(
        userId: UUID,
        callback: @escaping ((_ resp: APIResponseGeneric<RequestUserCancelationResponse>?) -> ())
    ) {
        sendPost(
            rout,
            version,
            "requestUserCancelation",
            RequestUserCancelationRequest(userId: userId)
        ) { data in
            guard let data else {
                callback(nil)
                return
            }

            do {
                callback(try decodeAPIResponse(APIResponseGeneric<RequestUserCancelationResponse>.self, from: data))
            } catch {
                print("🔴 API_DECODING_ERROR")
                print(error)
                callback(nil)
            }
        }
    }
}
