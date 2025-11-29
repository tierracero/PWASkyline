//
//  CustPOC+MermProductsInventory.swift
//
//
//  Created by Victor Cantu on 6/18/24.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustPOCComponents {
    
    static func mermProductsInventory(
        storeId: UUID,
        items: [UUID],
        reason: String,
        callback: @escaping (( _ resp: APIResponseGeneric<CustFiscalInventoryControl>?) -> ())
    ) {
        sendPost(
            rout,
            version,
            "mermProductsInventory",
            MermProductsInventoryRequest(
                storeId: storeId,
                items: items,
                reason: reason
            )
        ) { data in
            guard let data else{
                callback(nil)
                return
            }
            do{
                callback(try JSONDecoder().decode(APIResponseGeneric<CustFiscalInventoryControl>.self, from: data))
            }
            catch{
                print(error)
                callback(nil)
            }
        }
    }
}
