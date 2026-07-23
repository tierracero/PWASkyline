//
//  Cust+AccountBalance.swift
//  
//
//  Created by Victor Cantu on 12/6/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustComponents {
    
    static func accountBalance(
        callback: @escaping ( (_ resp: APIResponseGeneric<AccountBalanceResponse>?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "accountBalance",
            EmptyPayload()
        ) { payload in
            
            guard let data = payload else{
                callback(nil)
                return
            }
            
            do{
                let resp = try decodeAPIResponse(APIResponseGeneric<AccountBalanceResponse>.self, from: data)
                callback(resp)
            }
            catch{
                print("🔴 API_DECODING_ERROR")
                print(error)
                callback(nil)
            }
        }
    }
}
