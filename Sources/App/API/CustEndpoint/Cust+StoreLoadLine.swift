//
//  Cust+StoreLoadLine.swift
//  
//
//  Created by Victor Cantu on 1/29/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustAPIEndpointV1 {
        
    static func storeLoadLine(
        id: UUID,
        callback: @escaping ( (_ resp: APIResponseGeneric<StoreLoadLineResponse>?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "storeLoadLine",
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
                let resp = try JSONDecoder().decode(APIResponseGeneric<StoreLoadLineResponse>.self, from: data)
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
