//
//  API+Store+POCs.swift
//  
//
//  Created by Victor Cantu on 9/16/22.
//

import TCFundamentals
import Foundation
import TCFundamentals
import TCFireSignal

extension APIComponents {
    
    static func storePOCs(
        id: UUID?,
        rel: CustProductType,
        curObjs: [APIStoreSincObject],
        curImgs: [APIStoreSincObject],
        callback: @escaping ( (_ resp: APIResponseGeneric<StorePOCsResponse>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "store/pocs",
            StorePOCsRequest(id: id, rel: rel, curObjs: curObjs, curImgs: curImgs)
        ) { resp in
            guard let data = resp else{
                callback(nil)
                return
            }
            
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<StorePOCsResponse>.self, from: data)
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

