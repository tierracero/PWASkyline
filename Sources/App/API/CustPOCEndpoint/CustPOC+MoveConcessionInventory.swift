//
// CustPOC+MoveConcessionInventory.swift
//


import Foundation
import TCFundamentals
import TCFireSignal

extension CustPOCComponents {
    
    static func moveConcessionInventory(
        accountId: UUID,
        itemIds: [UUID],
        bodegaId: UUID?,
        callback: @escaping ( (_ resp: APIResponse?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "moveConcessionInventory",
            MoveConcessionInventoryRequest(
                accountId: accountId,
                itemIds: itemIds,
                bodegaId: bodegaId
            )
        ) { data in
            guard let data else{
                callback(nil)
                return
            }
            do{
                callback(try JSONDecoder().decode(APIResponse.self, from: data))
            }
            catch{
                print(#function)
                print(error)
                callback(nil)
            }
        }
    }
}
