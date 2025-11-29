//
//  Cust+GetStoreCategory.swift
//  
//
//  Created by Victor Cantu on 1/30/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustComponents {
        
    static func getStoreCategory(
        id: UUID,
        callback: @escaping ( (_ resp: APIResponseGeneric<CustStoreCatsAPI>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "getStoreCategory",
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
                let resp = try JSONDecoder().decode(APIResponseGeneric<CustStoreCatsAPI>.self, from: data)
                
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
