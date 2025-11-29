//
//  CustPOC+CreateInventoryTransfer.swift
//  
//
//  Created by Victor Cantu on 4/29/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustPOCComponents {
    
    static func createInventoryTransfer(
        fromStore: UUID,
        toStore: UUID,
        items: [UUID],
        callback: @escaping ( (_ resp: APIResponseGeneric<CustFiscalInventoryControl>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "createInventoryTransfer",
            CreateInventoryTransferRequest(
                fromStore: fromStore,
                toStore: toStore,
                items: items
            )
        ) { payload in
            guard let data = payload else{
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<CustFiscalInventoryControl>.self, from: data)
                callback(resp)
            }
            catch{
                print(error)
                callback(nil)
            }
        }
    }
}
