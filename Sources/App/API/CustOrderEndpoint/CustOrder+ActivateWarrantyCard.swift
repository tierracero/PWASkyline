//
//  CustOrder+ActivateWarrantyCard.swift
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustOrderComponents {

    /// Activates a warranty card for an order.
    static func activateWarrantyCard(
        cardId: UUID,
        type: ActivateWarrantyCardType,
        callback: @escaping ((_ resp: APIResponse?) -> ())
    ) {
        sendPost(
            rout,
            version,
            "activateWarrantyCard",
            ActivateWarrantyCardRequest(
                cardId: cardId,
                type: type
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
