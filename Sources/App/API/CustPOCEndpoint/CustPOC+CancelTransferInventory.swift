//
//  CustPOC+CancelTransferInventory.swift
//  
//
//  Created by Victor Cantu on 8/11/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustPOCComponents {
    
    static func cancelTransferInventory(
        docid: UUID,
        reason: String,
        callback: @escaping ( (_ resp: APIResponse?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "cancelTransferInventory",
            CancelTransferInventoryRequest(
                docid: docid,
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

