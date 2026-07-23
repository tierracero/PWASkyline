//
//  CustOrder+GetPendingConsumables.swift
//
//
//  Created by Victor Cantu on 12/7/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustOrderComponents {
    
    static func getPendingConsumables (
        callback: @escaping ( (_ resp: APIResponseGeneric<GetPendingConsumablesResponse>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "getPendingConsumables",
            EmptyPayload()
        ) { data in
            guard let data else{
                callback(nil)
                return
            }
            do{
                let resp = try decodeAPIResponse(APIResponseGeneric<GetPendingConsumablesResponse>.self, from: data)
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
