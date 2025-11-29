//
//  Cust+CTAMResolve.swift
//  
//
//  Created by Victor Cantu on 4/28/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustComponents {
    
    static func CTAMResolve(
        alertid: UUID,
        action: CustTaskAuthorizationManagerStatus,
        responseMessage: String,
        callback: @escaping ( (_ resp: APIResponse?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "CTAMResolve",
            CTAMResolveRequest(
                alertid: alertid,
                action: action,
                responseMessage: responseMessage
            )
        ) { payload in
            
            guard let payload else{
                callback(nil)
                return
            }
            do{
                callback(try JSONDecoder().decode(APIResponse.self, from: payload))
            }
            catch{
                print("🔴 API_DECODING_ERROR")
                print(error)
                callback(nil)
            }
        }
    }
}
