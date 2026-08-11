//
//  CustUsername+ResetPassword.swift
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustUsernameComponents {

    static func resetPassword(
        id: UUID,
        callback: @escaping ((_ resp: APIResponse?) -> ())
    ) {
        sendPost(
            rout,
            version,
            "resetPassword",
            ResetPasswordRequest(id: id)
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
