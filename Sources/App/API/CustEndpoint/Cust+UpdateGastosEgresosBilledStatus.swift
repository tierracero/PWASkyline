//
//  Cust+UpdateGastosEgresosBilledStatus.swift
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustComponents {

    static func updateGastosEgresosBilledStatus(
        gastoId: UUID,
        billedStatus: BillingPaidStatus,
        callback: @escaping ((_ resp: APIResponseGeneric<CustGastosEgresos>?) -> ())
    ) {
        sendPost(
            rout,
            version,
            "updateGastosEgresosBilledStatus",
            UpdateGastosEgresosBilledStatusRequest(
                gastoId: gastoId,
                billedStatus: billedStatus
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
