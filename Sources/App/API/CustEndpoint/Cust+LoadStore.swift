//
//  Cust+LoadStore.swift
//  
//
//  Created by Victor Cantu on 7/5/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustAPIEndpointV1 {
        
    static func loadStore(
        storeId: UUID,
        callback: @escaping ( (_ resp: APIResponseGeneric<LoadStoreResponse>?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "loadStore",
            LoadStoreRequest(
                storeId: storeId
            )
        ) { data in
            
            guard let data else{
                callback(nil)
                return
            }
            
            do{
                callback(try JSONDecoder().decode(APIResponseGeneric<LoadStoreResponse>.self, from: data))
            }
            catch{
                print("🔴 API_DECODING_ERROR")
                print(error)
                callback(nil)
            }
        }
    }
}


