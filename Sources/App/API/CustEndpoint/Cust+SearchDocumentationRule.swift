//
//  Cust+SearchDocumentationRule.swift
//  
//
//  Created by Victor Cantu on 6/15/24.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustAPIEndpointV1 {
    
    static func searchDocumentationRule(
        term: String,
        callback: @escaping ( (_ resp: [CustDocumentationRuleManagerQuick]) -> () )
    ) {
        sendPost(
            rout,
            version,
            "searchDocumentationRule",
            SearchDocumentationRuleRequest(
                term: term
            )
        ) { data in
            guard let data else{
                callback([])
                return
            }
            do{
                let resp = try JSONDecoder().decode([CustDocumentationRuleManagerQuick].self, from: data)
                callback(resp)
            }
            catch{
                callback([])
            }
        }
    }
}
