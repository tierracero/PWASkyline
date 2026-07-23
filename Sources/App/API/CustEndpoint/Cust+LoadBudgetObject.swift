//
//  Cust+LoadBudgetObject.swift
//  
//
//  Created by Victor Cantu on 3/27/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustComponents {
        
    static func loadBudgetObject(
        id: HybridIdentifier,
        store: UUID,
        callback: @escaping ( (_ resp: APIResponseGeneric<LoadBudgetObjectResponse>?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "loadBudgetObject",
            LoadBudgetObjectRequest(
                id: id,
                store: store
            )
        ) { payload in
            
            guard let data = payload else {
                callback(nil)
                return
            }
            
            do{
                let resp = try decodeAPIResponse(APIResponseGeneric<LoadBudgetObjectResponse>.self, from: data)
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


