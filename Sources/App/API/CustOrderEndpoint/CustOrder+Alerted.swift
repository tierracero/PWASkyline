//
//  CustOrder+Alerted.swift
//
//
//  Created by Victor Cantu on 10/27/23.
//

import Foundation
import TCFundamentals
import TCFireSignal


extension CustOrderComponents {
    
    static func alerted (
        orderId: UUID,
        reason: String,
        state: Bool,
        callback: @escaping ( (_ resp: APIResponse?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "alerted",
            AlertedRequest(
                orderId: orderId,
                reason: reason,
                state: state
            )
        ) { data in
            guard let data else{
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

