//
//  Cust+GetDocumentationRule.swift
//  
//
//  Created by Victor Cantu on 6/15/24.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustAPIEndpointV1 {
    
    static func getDocumentationRule(
        ruleId: UUID,
        callback: @escaping ( (_ resp: APIResponseGeneric<GetDocumentationRuleResponse>?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "getDocumentationRule",
            GetDocumentationRuleRequest(
                ruleId: ruleId
            )
        ) { data in
            guard let data else{
                callback(nil)
                return
            }
            do{
                callback(try JSONDecoder().decode(APIResponseGeneric<GetDocumentationRuleResponse>.self, from: data))
            }
            catch{
                print("🔴 API_DECODING_ERROR")
                print(error)
                callback(nil)
            }
        }
    }
}
