//
//  CustPOC+MoveConcessionInventoryToOrder.swift
//  TCFireSignal
//
//  Created by Victor Cantu on 11/27/25.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustPOCComponents {
    
    static func moveConcessionInventoryToOrder(
            accountId: UUID,
            bodegaId: UUID?,
            orderId: UUID,
            itemIds: [UUID],
        callback: @escaping ( (_ resp: APIResponse?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "moveConcessionInventoryToOrder",
            MoveConcessionInventoryToOrderRequest(
                accountId: accountId,
                bodegaId: nil,
                orderId: orderId,
                itemIds: itemIds
            )
        ) { data in
            guard let data else {
                callback(nil)
                return
            }
            do{
                callback(try JSONDecoder().decode(APIResponse.self, from: data))
            }
            catch{
                print(error)
                callback(nil)
            }
        }
    }
}
