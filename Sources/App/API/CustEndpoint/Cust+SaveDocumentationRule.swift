//
//  Cust+SaveDocumentationRule.swift
//  
//
//  Created by Victor Cantu on 6/15/24.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustAPIEndpointV1 {
    
    static func saveDocumentationRule(
        ruleId: UUID,
        name: String,
        description: String,
        callback: @escaping ( (_ resp: APIResponse?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "saveDocumentationRule",
            SaveDocumentationRuleRequest(
                ruleId: ruleId,
                name: name,
                description: description
            )
        ) { data in
            guard let data else{
                callback(nil)
                return
            }
            do{
                callback(try JSONDecoder().decode(APIResponse.self, from: data))
            }
            catch{
                print("🔴 API_DECODING_ERROR")
                print(error)
                callback(nil)
            }
        }
    }
}
