//
//  CustOrder+LoadOrder.swift
//
//
//  Created by Victor Cantu on 10/11/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustOrderComponents {
    
    static func loadOrder (
        identifier: HybridIdentifier,
        modifiedAt: Int64?,
        callback: @escaping ( (_ resp: APIResponseGeneric<LoadOrderResponseType>?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "loadOrder",
            LoadOrderRequest(
                identifier: identifier,
                modifiedAt: modifiedAt
            )
        ) { resp in
            guard let data = resp else{
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<LoadOrderResponseType>.self, from: data)
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
