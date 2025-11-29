//
//  CustAccount+AddPayment.swift
//  
//
//  Created by Victor Cantu on 3/23/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustAccountComponents {
    
    public static func addPayment(
        accountid: UUID,
        storeId: UUID?,
        fiscCode: FiscalPaymentCodes,
        description: String,
        cost: Float,
        provider: String,
        lastFour: String,
        auth: String,
        callback: @escaping ( (_ resp: APIResponseGeneric<AddPaymentResponse>?) -> () )) {
        
        sendPost(
            rout,
            version,
            "addPayment",
            AddPaymentRequest(
                accountid: accountid, 
                storeId: storeId,
                fiscCode: fiscCode,
                description: description,
                cost:  cost,
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
                let resp = try JSONDecoder().decode(APIResponseGeneric<AddPaymentResponse>.self, from: data)
                callback(resp)
            }
            catch{
                print("⭕️ load \(#function)")
                print(error)
                callback(nil)
            }
        }
    }
}
