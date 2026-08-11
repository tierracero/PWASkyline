//
//  CustUsername+PreRequestUsername.swift
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustUsernameComponents {

    static func preRequestUsername(
        store: UUID,
        callback: @escaping ((_ resp: APIResponseGeneric<PreRequestUsernameResponse>?) -> ())
    ) {
        sendPost(
            rout,
            version,
            "preRequestUsername",
            PreRequestUsernameRequest(store: store)
        ) { data in
            guard let data else {
                callback(nil)
                return
            }

            do {
                callback(try decodeAPIResponse(APIResponseGeneric<PreRequestUsernameResponse>.self, from: data))
            } catch {
                print("🔴 API_DECODING_ERROR")
                print(error)
                callback(nil)
            }
        }
    }
}
