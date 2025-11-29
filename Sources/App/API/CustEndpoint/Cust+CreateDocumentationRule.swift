//
//  Cust+AddDocumentationRule.swift
//
//
//  Created by Victor Cantu on 6/15/24.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustComponents {
    
    static func addDocumentationRule(
        bookId: UUID,
        name: String,
        description: String,
        callback: @escaping ( (_ resp: APIResponseGeneric<CustDocumentationRuleManager>?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "addDocumentationRule",
            AddDocumentationRuleRequest(
                bookId: bookId,
                name: name,
                description: description
            )
        ) { data in
            guard let data else{
                callback(nil)
                return
            }
            do{
                callback(try JSONDecoder().decode(APIResponseGeneric<CustDocumentationRuleManager>.self, from: data))
            }
            catch{
                print("🔴 API_DECODING_ERROR")
                print(error)
                callback(nil)
            }
        }
    }
}
