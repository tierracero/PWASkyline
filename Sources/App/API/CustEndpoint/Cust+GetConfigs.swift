//
//  Cust+GetConfigs.swift
//  
//
//  Created by Victor Cantu on 9/9/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustComponents {
        
    static func getConfigs(
        callback: @escaping ( (_ resp: APIResponseGeneric<GetConfigsResponse>? ) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "getConfigs",
            EmptyPayload()
        ) { payload in
            
            guard let data = payload else{
                callback(nil)
                return
            }
            
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<GetConfigsResponse>.self, from: data)
                callback(resp)
            }
            catch {
                callback(nil)
            }
            
        }
    }
}
