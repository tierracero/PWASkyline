//
//  CustOrder+GetWarrantyCard.swift
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustOrderComponents {

    /// Loads an active warranty card by its identifier or code.
    static func getWarrantyCard(
        id: RequstWarrantyCardType,
        callback: @escaping ((_ resp: APIResponseGeneric<GetWarrantyCardResponse>?) -> ())
    ) {
        sendPost(
            rout,
            version,
            "getWarrantyCard",
            GetWarrantyCardRequest(id: id)
        ) { data in
            guard let data else {
                callback(nil)
                return
            }

            do {
                callback(
                    try decodeAPIResponse(
                        APIResponseGeneric<GetWarrantyCardResponse>.self,
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
