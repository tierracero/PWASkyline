//
//  CustAccount+RequestSiweCard.swift
//  
//
//  Created by Victor Cantu on 9/15/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustAccountComponents {
    
    public static func requestSiweCard(
        custAcct: UUID,
        cardId: String,
        cc: Countries,
        mobile: String,
        callback: @escaping ( (_ resp: APIResponseGeneric<RequestSiweCardResponse>?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "requestSiweCard",
            RequestSiweCardRequest(
                custAcct: custAcct,
                cardId: cardId,
                cc: cc,
                mobile: mobile
            )
        ) { payload in
            guard let payload else{
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<RequestSiweCardResponse>.self, from: payload)
                callback(resp)
            }
            catch{
                print("⭕️ loadDetails \(#function)")
                print(error)
                callback(nil)
            }
        }
    }
}
