//
//  Cust+RequestPasswordRecovery.swift
//  
//
//  Created by Victor Cantu on 8/25/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustComponents {
        
    static func requestPasswordRecovery(
        username: String,
        callback: @escaping ( (_ resp: APIResponseGeneric<RequestPasswordRecoveryResponse>?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "requestPasswordRecovery",
            RequestPasswordRecoveryRequest(
                username: username
            )
        ) { payload in
            
            guard let data = payload else{
                callback(nil)
                return
            }
            
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<RequestPasswordRecoveryResponse>.self, from: data)
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
