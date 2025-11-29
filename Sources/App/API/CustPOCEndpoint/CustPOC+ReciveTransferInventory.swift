//
//  CustPOC+ReciveTransferInventory.swift
//  
//
//  Created by Victor Cantu on 4/28/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustPOCComponents {
    
    static func reciveTransferInventory(
        docid: UUID,
        callback: @escaping ( (_ resp: APIResponse?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "reciveTransferInventory",
            ReciveTransferInventoryRequest(
                docid: docid
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

