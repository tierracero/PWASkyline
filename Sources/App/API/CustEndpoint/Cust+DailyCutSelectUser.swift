//
//  Cust+DailyCutSelectUser.swift
//  
//
//  Created by Victor Cantu on 7/3/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustAPIEndpointV1 {
    
    static func dailyCutSelectUser(
        callback: @escaping ( (_ resp: APIResponseGeneric<DailyCutSelectUserResponse>?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "dailyCutSelectUser",
            EmptyPayload()
        ) { payload in
            
            guard let payload else {
                callback(nil)
                return
            }
            
            do {
                callback(try JSONDecoder().decode(APIResponseGeneric<DailyCutSelectUserResponse>.self, from: payload))
            }
            catch{
                print("🔴 API_DECODING_ERROR")
                print(error)
                callback(nil)
            }
            
        }
    }
}
