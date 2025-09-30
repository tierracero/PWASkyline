//
//  API+Store+Deps.swift
//  
//
//  Created by Victor Cantu on 9/16/22.
//

import TCFundamentals
import Foundation
import TCFundamentals
import TCFireSignal

extension APIEndpointV1 {
    
    static func storeDeps(
        curObjs: [APIStoreSincObject],
        callback: @escaping ( (_ resp: APIResponseGeneric<StoreDepsResponse>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "store/deps",
            StoreDepsRequest(curObjs: curObjs)
        ) { resp in
            guard let data = resp else{
                callback(nil)
                return
            }
            
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<StoreDepsResponse>.self, from: data)
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
