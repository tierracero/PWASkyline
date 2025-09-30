//
//  Cust+GetDocumentationRules.swift
//  
//
//  Created by Victor Cantu on 6/15/24.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustAPIEndpointV1 {
    
    static func getDocumentationRules(
        callback: @escaping ( (_ resp: APIResponseGeneric<GetDocumentationRulesResponse>?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "getDocumentationRules",
            EmptyPayload()
        ) { data in
            guard let data else{
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<GetDocumentationRulesResponse>?.self, from: data)
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
