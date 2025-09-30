//
//  Cust+LoadMessaging.swift
//  
//
//  Created by Victor Cantu on 8/6/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustAPIEndpointV1 {
        
    static func loadMessaging(
        callback: @escaping ( (_ resp: [LoadMessaging]?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "loadMessaging",
            EmptyPayload()
        ) { payload in
            
            guard let data = payload else{
                callback(nil)
                return
            }
            
            do{
                let resp = try JSONDecoder().decode([LoadMessaging].self, from: data)
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
