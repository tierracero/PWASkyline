//
//  Cust+DismissMessage.swift
//  
//
//  Created by Victor Cantu on 4/6/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustComponents {
        
    static func dismissMessage(
        alertid: UUID,
        orderid: UUID?,
        callback: @escaping ( (_ resp: APIResponse?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "dismissMessage",
            DismissMessageRequest(
                alertid: alertid,
                orderid: orderid
            )
        ) { payload in
            
            guard let data = payload else{
                callback(nil)
                return
            }
            
            do{
                let resp = try JSONDecoder().decode(APIResponse?.self, from: data)
                callback(resp)
            }
            catch {
                callback(nil)
            }
            
        }
    }
}
