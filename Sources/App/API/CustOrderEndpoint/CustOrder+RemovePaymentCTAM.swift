//
//  CustOrder+RemovePaymentCTAM.swift
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustOrderComponents {

    static func removePaymentCTAM(
        orderId: UUID,
        paymentId: UUID,
        callback: @escaping (APIResponseGeneric<RemovePaymentCTAMResponse>?) -> Void
    ) {
        sendPost(
            rout,
            version,
            "removePaymentCTAM",
            RemovePaymentCTAMRequest(orderId: orderId, paymentId: paymentId)
        ) { data in
            guard let data else {
                callback(nil)
                return
            }

            do {
                callback(try decodeAPIResponse(APIResponseGeneric<RemovePaymentCTAMResponse>.self, from: data))
            } catch {
                print("🔴 API_DECODING_ERROR")
                print(error)
                callback(nil)
            }
        }
    }
}
