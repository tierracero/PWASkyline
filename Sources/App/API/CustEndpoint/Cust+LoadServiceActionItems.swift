//
//  Cust+LoadServiceActionItems.swift
//
//
//  Created by Victor Cantu on 7/16/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustComponents {
        
    static func loadServiceActionItems(
        id: UUID,
        callback: @escaping ( (_ resp: APIResponseGeneric<LoadServiceSaleActionItemsResponse>?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "loadServiceActionItems",
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
                let resp = try JSONDecoder().decode(APIResponseGeneric<LoadServiceSaleActionItemsResponse>.self, from: data)
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

