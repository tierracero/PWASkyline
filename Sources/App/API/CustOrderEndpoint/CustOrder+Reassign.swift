//
//  CustOrder+Reassign.swift
//  
//
//  Created by Victor Cantu on 4/26/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustOrderComponents {
    
    static func reassign (
        orderid: UUID,
        userid: UUID,
        callback: @escaping ( (_ resp: APIResponse?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "reassign",
            ReassignRequest(
                orderid: orderid,
                userid: userid
            )
        ) { data in
            
            guard let data else{
                callback(nil)
                return
            }
            do{
                let data = try JSONDecoder().decode(APIResponse.self, from: data)
                callback(data)
            }
            catch{
                print("🔴  reassign  🔴")
                print(error)
                callback(nil)
            }
        }
        
    }
}

