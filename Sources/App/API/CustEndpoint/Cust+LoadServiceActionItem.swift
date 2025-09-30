//
//  Cust+LoadServiceActionItem.swift
//  
//
//  Created by Victor Cantu on 4/2/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustAPIEndpointV1 {
        
    static func loadServiceActionItem(
        id: UUID,
        callback: @escaping ( (_ resp: APIResponseGeneric<CustSaleActionItem>?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "loadServiceActionItem",
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
                let resp = try JSONDecoder().decode(APIResponseGeneric<CustSaleActionItem>.self, from: data)
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
