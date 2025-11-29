//
//  API+Store+Cats.swift
//  
//
//  Created by Victor Cantu on 9/16/22.
//

import Foundation
import TCFundamentals
import TCFireSignal
import TCFundamentals

extension APIComponents {
    
    static func storeCats(
        id: UUID?,
        curObjs: [APIStoreSincObject],
        callback: @escaping ( (_ resp: APIResponseGeneric<StoreCatsResponse>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "store/cats",
            StoreCatsRequest(id: id, curObjs: curObjs)
        ) { resp in
            guard let data = resp else{
                callback(nil)
                return
            }
            
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<StoreCatsResponse>.self, from: data)
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

