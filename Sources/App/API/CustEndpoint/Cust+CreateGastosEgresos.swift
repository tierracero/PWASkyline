//
//  Cust+CreateGastosEgresos.swift
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustComponents {

    static func createGastosEgresos(
        ownerType: CustGastosEgresosType,
        owner: UUID,
        description: String,
        vendorId: UUID? = nil,
        receiptType: GastosEgresoReciptType,
        receiptSeries: String,
        receiptAmount: Int64,
        receiptAudited: Bool,
        billedStatus: BillingPaidStatus = .unpaid,
        callback: @escaping ((_ resp: APIResponseGeneric<CustGastosEgresos>?) -> ())
    ) {
        sendPost(
            rout,
            version,
            "createGastosEgresos",
            CreateGastosEgresosRequest(
                ownerType: ownerType,
                owner: owner,
                description: description,
                vendorId: vendorId,
                receiptType: receiptType,
                receiptSeries: receiptSeries,
                receiptAmount: receiptAmount,
                receiptAudited: receiptAudited,
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
