//
//  CustOrder+Reactivate.swift
//  
//
//  Created by Victor Cantu on 5/11/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustOrderComponents {
    
    static func reactivate (
        ids: [ReactivateObject],
        orderid: UUID,
        sendComm: Bool,
        callback: @escaping ( (_ resp: APIResponse?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "reactivate",
            ReactivateRequest(ids: ids, orderid: orderid, sendComm: sendComm)
        ) { resp in
            guard let data = resp else{
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponse.self, from: data)
                callback(resp)
            }
            catch{
                print("🔴 API_DECODING_ERROR")
                print(error)
                callback(nil)
            }
        }
        
    }
}
