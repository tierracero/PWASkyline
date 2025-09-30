//
//  CustOrder+GetPendingConsumable.swift
//  
//
//  Created by Victor Cantu on 12/7/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustOrderEndpointV1 {
    
    ///
    static func getPendingConsumable (
        consumableId: UUID,
        callback: @escaping ( (_ resp: APIResponseGeneric<PendingConsumableManager>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "getPendingConsumable",
            GetPendingConsumableRequest(
                consumableId: consumableId
            )
        ) { resp in
            guard let data = resp else{
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<PendingConsumableManager>.self, from: data)
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
