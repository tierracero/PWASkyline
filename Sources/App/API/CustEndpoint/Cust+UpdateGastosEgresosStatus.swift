//
//  Cust+UpdateGastosEgresosStatus.swift
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustComponents {

    static func updateGastosEgresosStatus(
        gastoId: UUID,
        status: BillingStatus,
        callback: @escaping ((_ resp: APIResponseGeneric<CustGastosEgresos>?) -> ())
    ) {
        sendPost(
            rout,
            version,
            "updateGastosEgresosStatus",
            UpdateGastosEgresosStatusRequest(
                gastoId: gastoId,
                status: status
            )
        ) { data in
            guard let data else {
                callback(nil)
                return
            }

            do {
                callback(
                    try decodeAPIResponse(
                        APIResponseGeneric<CustGastosEgresos>.self,
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
