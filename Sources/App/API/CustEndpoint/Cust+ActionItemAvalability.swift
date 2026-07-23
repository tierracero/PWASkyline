//
//  Cust+ActionItemAvalability.swift
//  
//
//  Created by Victor Cantu on 4/4/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustComponents {
    
    static func actionItemAvalability(
        /// saleItem, actionItem
        type: SaleActionType,
        id: UUID?,
        name: String,
        callback: @escaping ( (_ resp: APIResponseGeneric<ActionItemAvalabilityResponse>?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "actionItemAvalability",
            ActionItemAvalabilityRequest(
                type: type,
                id: id,
                name: name
            )
        ) { data in
            
            guard let data else {
                callback(nil)
                return
            }
            
            do {
                callback(try decodeAPIResponse(APIResponseGeneric<ActionItemAvalabilityResponse>.self, from: data))
            }
            catch {
                callback(nil)
            }
        }
    }
}

