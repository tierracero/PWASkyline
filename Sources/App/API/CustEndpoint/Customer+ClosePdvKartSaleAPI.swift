//
//  Customer+ClosePdvKartSaleAPI.swift
//
//
//  Created by Victor Cantu on 2/23/22.
//

import Foundation
import TCFundamentals
import TCFireSignal
import TCFundamentals

extension CustAPIEndpointV1 {
    
    static func closePdvKartSale(
        custAcct: UUID?,
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
        callback: @escaping ( (_ resp: APIResponseGeneric<ClosePDVKartSaleResponse>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "closePdvKartSale",
            ClosePDVKartSaleRequest(
                custAcct: custAcct,
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
                //public var credit: Bool
                ///Ejemplo: efectivo, chequeNominativo, transferenciaElectronicaDeFondos ...
                fiscCode: fiscCode,
                description: description,
                amount: amount,
                provider: provider,
                lastFour: lastFour,
                auth: auth
            )
        ) { payload in
            guard let data = payload else{
                callback(nil)
                return
            }
            
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<ClosePDVKartSaleResponse>.self, from: data)
                callback(resp)
            }
            catch{
                
                print(error)
                
                callback(nil)
            }
        }
    }
}
