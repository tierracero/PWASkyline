//
//  Rewards+Purchase.swift
//
//
//  Created by Victor Cantu on 2/23/24.
//

import Foundation
import TCFundamentals
import TCFireSignal
import TaecelAPICore

extension RewardsComponents {
    
    public static func purchase(
        cardId: String,
        custAcctId: UUID,
        product: String,
        refrence: String,
        price: Double?,
        callback: @escaping ( (_ resp: APIResponseGeneric<PurchaseResponse>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "purchase",
            PurchaseRequest(
                cardId: cardId,
                custAcctId: custAcctId,
                product: product,
                refrence: refrence,
                price: price
            )
        ) { data in
            guard let data else{
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<PurchaseResponse>.self, from: data)
                callback(resp)
            }
            catch{
                print("⭕️ loadFIAccounts")
                print(error)
                callback(nil)
            }
        }
    }
}

