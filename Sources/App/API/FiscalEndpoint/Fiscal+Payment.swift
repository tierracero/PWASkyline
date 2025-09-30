//
//  Fiscal+Payment.swift
//  
//
//  Created by Victor Cantu on 3/1/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension FiscalEndpointV1 {
    
    static func payment(
        storeId: UUID?,
        ids: [UUID],
        description: String,
        payment: Int64,
        comment: String,
        officialDate: Int64?,
        forma: FiscalPaymentCodes,
        provider: String,
        auth: String,
        lastFour: String,
        callback: @escaping ( (_ resp: APIResponseGeneric<FIAccountsServices>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "payment2",
            PaymentRequest2(
                storeId: storeId,
                ids: ids,
                description: description,
                payment: payment,
                comment: comment,
                officialDate: officialDate,
                forma: forma,
                provider: provider,
                auth: auth,
                lastFour: lastFour
            )
        ) { payload in
            
            guard let data = payload else{
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<FIAccountsServices>.self, from: data)
                callback(resp)
            }
            catch{
                print(error)
                callback(nil)
            }
        }
    }
}
