//
//  Theme+DeleteViewProfile.swift
//

import Foundation
import TCFundamentals
import TCFireSignal
import TaecelAPICore

extension ThemeComponents {

    public static func deleteViewProfile(
        id: UUID,
        callback: @escaping ((_ resp: APIResponse?) -> ())
    ) {
        sendPost(
            rout,
            version,
            "deleteViewProfile",
            DeleteViewProfileRequest(id: id)
        ) { data in
            guard let data else {
                callback(nil)
                return
            }

            do {
                callback(try decodeAPIResponse(APIResponse.self, from: data))
            } catch {
                print("⭕️ \(#file)")
                print(error)
                callback(nil)
            }
        }
    }
}
