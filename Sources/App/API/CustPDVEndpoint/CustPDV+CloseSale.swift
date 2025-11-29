//
//  CustPDV+CloseSale.swift
//  
//
//  Created by Victor Cantu on 3/18/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustPDVComponents {
    
    static func closeSale(
        //channel: SaleType, GOKU
        custAcct: UUID?,
        cardId: String?,
        custSubAcct: UUID?,
        custSale: UUID?,
        firstName: String,
        lastName: String,
        mobile: String,
        comment: String,
        store: UUID,
        saleObject: [SaleObjectItem],
        saleObjectService: [SaleObjectItem],
        saleObjectManual: [SaleObjectItem],
        /// pdv, order, eSale, default
        saleType: CustPOCInventorySoldType,
        //public var credit: Bool
        ///Ejemplo: efectivo, chequeNominativo, transferenciaElectronicaDeFondos ...
        fiscCode: FiscalPaymentCodes,
        description: String,
        amount: Float,
        provider: String,
        lastFour: String,
        auth: String,
        rewardsPoints: Int?,
        callback: @escaping ((
            _ resp: APIResponseGeneric<CloseSaleResponse>?) -> ()
        )
    ) {
        
        sendPost(
            rout,
            version,
            "closeSale",
            CloseSaleRequest(
                channel: .pos,
                custAcct: custAcct,
                cardId: cardId,
                custSubAcct: custSubAcct,
                custSale: custSale,
                firstName: firstName,
                lastName: lastName,
                mobile: mobile,
                comment: comment,
                store: store,
                saleObject: saleObject,
                saleObjectService: saleObjectService,
                saleObjectManual: saleObjectManual,
                /// pdv, order, eSale, default
                saleType: saleType,
                credit: false,
                //public var credit: Bool
                ///Ejemplo: efectivo, chequeNominativo, transferenciaElectronicaDeFondos ...
                fiscCode: fiscCode,
                description: description,
                amount: amount,
                provider: provider,
                lastFour: lastFour,
                auth: auth,
                rewardsPoints: rewardsPoints
            )
        ) { resp in
            
                guard let data = resp else {
                    callback(nil)
                    return
                }
            
                do{
                    let resp = try JSONDecoder().decode(APIResponseGeneric<CloseSaleResponse>.self, from: data)
                    callback(resp)
                }
                catch{
                    print(error)
                    callback(nil)
                }
            }
    }
}
