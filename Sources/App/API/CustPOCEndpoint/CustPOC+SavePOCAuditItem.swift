//
//  CustPOC+SavePOCAuditItem.swift
//  
//
//  Created by Victor Cantu on 8/29/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustPOCEndpointV1 {
    
    static func savePOCAuditItem(
        itemid: UUID,
        cost: Int64,
        price: Int64,
        link1: String,
        link2: String,
        callback: @escaping ( (_ resp: APIResponse?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "savePOCAuditItem",
            SavePOCAuditItemRequest(
                itemid: itemid,
                cost: cost,
                price: price,
                link1: link1,
                link2: link2
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
