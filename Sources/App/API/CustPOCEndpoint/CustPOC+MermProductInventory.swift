//
//  CustPOC+MermProductInventory.swift
//  
//
//  Created by Victor Cantu on 2/6/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustPOCEndpointV1 {
    
    static func mermProductInventory(
        ids: [UUID],
        pocid: UUID,
        storeName: String,
        reason: String,
        callback: @escaping ( (_ resp: APIResponse?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "mermProductInventory",
            MermProductInventoryRequest(
                ids: ids,
                pocid: pocid,
                storeName: storeName,
                reason: reason
            )
        ) { payload in
            guard let data = payload else{
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponse.self, from: data)
                callback(resp)
            }
            catch{
                print(error)
                callback(nil)
            }
        }
    }
}
