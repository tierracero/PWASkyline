//
//  Cust+SeccionNameAvalability.swift
//  
//
//  Created by Victor Cantu on 12/14/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustAPIEndpointV1 {
    
    static func seccionNameAvalability(
        name: String,
        bodegaID: UUID,
        seccionID: UUID?,
        callback: @escaping ( (_ resp: APIResponseGeneric<SeccionNameAvalabilityResponse>?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "seccionNameAvalability",
            SeccionNameAvalabilityRequest(
                name: name,
                bodegaID: bodegaID,
                seccionID: seccionID
            )
        ) { payload in
            guard let data = payload else{
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<SeccionNameAvalabilityResponse>.self, from: data)
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
