//
//  CustOrder+RemoveChargeCTAM.swift
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustOrderComponents {

    static func removeChargeCTAM(
        orderId: UUID,
        chargeId: UUID,
        callback: @escaping (APIResponseGeneric<RemoveChargeCTAMResponse>?) -> Void
    ) {
        sendPost(
            rout,
            version,
            "removeChargeCTAM",
            RemoveChargeCTAMRequest(orderId: orderId, chargeId: chargeId)
        ) { data in
            guard let data else {
                callback(nil)
                return
            }

            do {
                callback(try decodeAPIResponse(APIResponseGeneric<RemoveChargeCTAMResponse>.self, from: data))
            } catch {
                print("🔴 API_DECODING_ERROR")
                print(error)
                callback(nil)
            }
        }
    }
}
