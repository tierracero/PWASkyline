//
//  Cust+StoreLoadCategorie.swift
//  
//
//  Created by Victor Cantu on 1/29/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustComponents {
        
    static func storeLoadCategorie(
        id: UUID,
        callback: @escaping ( (_ resp: APIResponseGeneric<StoreLoadCategorieResponse>?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "storeLoadCategorie",
            APIRequestID(
                id: id,
                store: nil
            )
        ) { payload in
            
            guard let data = payload else{
                callback(nil)
                return
            }
            
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<StoreLoadCategorieResponse>.self, from: data)
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
