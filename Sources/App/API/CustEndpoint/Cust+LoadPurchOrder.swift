//
//  Cust+LoadPurchOrder.swift
//  
//
//  Created by Victor Cantu on 3/27/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustComponents {
        
    static func loadPurchOrder(
        id: HybridIdentifier,
        store: UUID,
        callback: @escaping ( (_ resp: APIResponseGeneric<LoadPurchOrderResponse>?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "loadPurchOrder",
            LoadPurchOrderRequest(
                id: id,
                store: store
            )
        ) { payload in
            
            guard let data = payload else {
                callback(nil)
                return
            }
            
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<LoadPurchOrderResponse>.self, from: data)
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

