//
//  Cust+AddUserPermition.swift
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustComponents {

    static func addUserPermition(
        _ permitType: CustPermitionTypes,
        _ permitId: UUID,
        userId: UUID,
        callback: @escaping ((_ resp: APIResponseGeneric<AddUserPermitionResponse>?) -> ())
    ) {
        sendPost(
            rout,
            version,
            "addUserPermition",
            AddUserPermitionRequest(
                type: permitType,
                id: permitId,
                UserID: userId
            )
        ) { data in
            guard let data else {
                callback(nil)
                return
            }

            do {
                callback(try decodeAPIResponse(APIResponseGeneric<AddUserPermitionResponse>.self, from: data))
            } catch {
                print("🔴 API_DECODING_ERROR")
                print(error)
                callback(nil)
            }
        }
    }
}
