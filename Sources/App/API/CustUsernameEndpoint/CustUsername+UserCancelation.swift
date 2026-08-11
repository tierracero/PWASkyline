//
//  CustUsername+UserCancelation.swift
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustUsernameComponents {

    static func userCancelation(
        userId: UUID,
        supervisorUserId: UUID? = nil,
        ordersWorkUserId: UUID? = nil,
        followupsWorkUserId: UUID? = nil,
        salesWorkUserId: UUID? = nil,
        tasksWorkUserId: UUID? = nil,
        inventoryWorkUserId: UUID? = nil,
        callback: @escaping ((_ resp: APIResponseGeneric<UserCancelationResponse>?) -> ())
    ) {
        sendPost(
            rout,
            version,
            "userCancelation",
            UserCancelationRequest(
                userId: userId,
                supervisorUserId: supervisorUserId,
                ordersWorkUserId: ordersWorkUserId,
                followupsWorkUserId: followupsWorkUserId,
                salesWorkUserId: salesWorkUserId,
                tasksWorkUserId: tasksWorkUserId,
                inventoryWorkUserId: inventoryWorkUserId
            )
        ) { data in
            guard let data else {
                callback(nil)
                return
            }

            do {
                callback(try decodeAPIResponse(APIResponseGeneric<UserCancelationResponse>.self, from: data))
            } catch {
                print("🔴 API_DECODING_ERROR")
                print(error)
                callback(nil)
            }
        }
    }
}
