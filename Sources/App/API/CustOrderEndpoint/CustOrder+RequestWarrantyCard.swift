//
//  CustOrder+RequestWarrantyCard.swift
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustOrderComponents {

    /// Requests a warranty card using the FireSignal route's legacy name.
    static func requestWorkLoadDay(
        id: RequstWarrantyCardType,
        callback: @escaping ((_ resp: APIResponseGeneric<RequestWorkLoadDayResponse>?) -> ())
    ) {
        sendPost(
            rout,
            version,
            "requestWorkLoadDay",
            RequestWarrantyCardRequest(id: id)
        ) { data in
            guard let data else {
                callback(nil)
                return
            }

            do {
                callback(
                    try decodeAPIResponse(
                        APIResponseGeneric<RequestWorkLoadDayResponse>.self,
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
