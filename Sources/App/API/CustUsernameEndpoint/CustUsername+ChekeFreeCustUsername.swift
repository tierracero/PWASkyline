//
//  CustUsername+ChekeFreeCustUsername.swift
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustUsernameComponents {

    static func chekeFreeCustUsername(
        username: String,
        callback: @escaping ((_ resp: APIResponse?) -> ())
    ) {
        sendPost(
            rout,
            version,
            "chekeFreeCustUsername",
            ChekeFreeCustUsernameRequest(username: username)
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
