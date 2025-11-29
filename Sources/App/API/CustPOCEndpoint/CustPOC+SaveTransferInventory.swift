//
//  CustPOC+SaveTransferInventory.swift
//  
//
//  Created by Victor Cantu on 10/6/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustPOCComponents {
    
    static func saveTransferInventory(
        docid: UUID,
        items: [SaveTransferInventoryObject],
        storeid: UUID,
        callback: @escaping ( (_ resp: APIResponse?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "saveTransferInventory",
            SaveTransferInventoryRequest(
                docid: docid,
                items: items,
                storeid: storeid
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

