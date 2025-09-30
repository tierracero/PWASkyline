//
//  CustAccount+ActivateSiweCard.swift
//  
//
//  Created by Victor Cantu on 9/17/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustAccountEndpointV1 {
    
    public static func activateSiweCard(
        custAcct: UUID,
        cardId: String,
        tokens: [String],
        pin: String,
        cc: Countries,
        mobile: String,
        callback: @escaping ( (_ resp: APIResponse?) -> () )) {
        
        sendPost(
            rout,
            version,
            "activateSiweCard",
            ActivateSiweCardRequest(
                custAcct: custAcct,
                cardId: cardId,
                tokens: tokens,
                pin: pin,
                cc: cc,
                mobile: mobile
            )
        ) { payload in
            
            guard let data = payload else{
                callback(nil)
                return
            }
            
            do{
                let resp = try JSONDecoder().decode(APIResponse.self, from: data)
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


