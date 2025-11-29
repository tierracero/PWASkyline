//
//  CustPOC+GetTransferInventory.swift
//  
//
//  Created by Victor Cantu on 10/4/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustPOCComponents {
    
    static func getTransferInventory(
        identifier: HybridIdentifier,
        callback: @escaping ( (_ resp: APIResponseGeneric<GetTransferInventoryResponse>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "getTransferInventory",
            GetTransferInventoryRequest(
                identifier: identifier
            )
        ) { payload in
            guard let data = payload else{
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<GetTransferInventoryResponse>.self, from: data)
                callback(resp)
            }
            catch{
                print(error)
                callback(nil)
            }
        }
    }
}
