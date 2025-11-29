//
//  Cust+Notifications.swift
//  
//
//  Created by Victor Cantu on 4/27/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustComponents {
        
    static func notifications(
        callback: @escaping ( (_ resp: APIResponseGeneric<[CustTaskAuthorizationManagerQuick]>?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "notifications",
            EmptyPayload()
        ) { data in
            
            guard let data else{
                callback(nil)
                return
            }
            
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<[CustTaskAuthorizationManagerQuick]>.self, from: data)
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
