//
//  CustOrder+RequestWarrantyCard.swift
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustOrderComponents {

    /// Requests a warranty card using the FireSignal route's legacy name.
    static func requestWarrantyCard(
        type: CustShortLinkManagerType,
        id: RequstWarrantyCardType,
        callback: @escaping ((_ resp: APIResponseGeneric<RequestWarrantyCardResponse>?) -> ())
    ) {
        sendPost(
            rout,
            version,
            "requestWarrantyCard",
            RequestWarrantyCardRequest(type: type, id: id)
        ) { data in
            guard let data else {
                callback(nil)
                return
            }

            do {
                callback(
                    try decodeAPIResponse(
                        APIResponseGeneric<RequestWarrantyCardResponse>.self,
                        from: data
                    )
                )
            } catch {
                print("🔴 API_DECODING_ERROR")
                print(error)
                callback(nil)
            }
        }
    }
}
