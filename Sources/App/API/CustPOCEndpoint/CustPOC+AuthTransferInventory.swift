//
//  CustPOC+AuthTransferInventory.swift
//  
//
//  Created by Victor Cantu on 10/6/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustPOCComponents {
    
    static func authTransferInventory(
        docid: UUID,
        items: [AuthTransferInventoryObject],
        place: InventoryPlaceType,
        callback: @escaping ( (_ resp: APIResponse?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "authTransferInventory",
            AuthTransferInventoryRequest(
                docid: docid,
                items: items,
                place: place
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

