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
        ) { payload in
            
            guard let data = payload else {
                callback(nil)
                return
            }
            
            do {
                let resp = try JSONDecoder().decode(APIResponseGeneric<ActionItemAvalabilityResponse>.self, from: data)
                callback(resp)
            }
            catch {
                callback(nil)
            }
        }
    }
}

