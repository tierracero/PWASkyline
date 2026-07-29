//
//  Cust+UpdateGastosEgresos.swift
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustComponents {

    static func updateGastosEgresos(
        gastoId: UUID,
        ownerType: CustGastosEgresosType,
        owner: UUID,
        description: String,
        vendorId: UUID? = nil,
        receiptType: GastosEgresoReciptType,
        receiptSeries: String,
        receiptAmount: Int64,
        receiptAudited: Bool,
        callback: @escaping ((_ resp: APIResponseGeneric<CustGastosEgresos>?) -> ())
    ) {
        sendPost(
            rout,
            version,
            "updateGastosEgresos",
            UpdateGastosEgresosRequest(
                gastoId: gastoId,
                description: description,
                vendorId: vendorId,
                receiptType: receiptType,
                receiptSeries: receiptSeries,
                receiptAmount: receiptAmount,
                receiptAudited: receiptAudited
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
