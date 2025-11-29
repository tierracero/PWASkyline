//
//  Cust+CreateDocumentationArticle.swift
//  
//
//  Created by Victor Cantu on 6/15/24.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustComponents {
    
    static func addDocumentationArticle(
        impact: CustDocumentationRuleImpact,
        bookId: UUID,
        ruleId: UUID,
        name: String,
        description: String,
        tags: [String],
        suggestedProcedure: [String],
        callback: @escaping ( (_ resp: APIResponseGeneric<CustDocumentationArticleManager>?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "addDocumentationArticle",
            AddDocumentationArticleRequest(
                impact: impact,
                bookId: bookId,
                ruleId: ruleId,
                name: name,
                description: description,
                tags: tags,
                suggestedProcedure: suggestedProcedure
            )
        ) { data in
            guard let data else{
                callback(nil)
                return
            }
            do{
                callback(try JSONDecoder().decode(APIResponseGeneric<CustDocumentationArticleManager>.self, from: data))
            }
            catch{
                print("🔴 API_DECODING_ERROR")
                print(error)
                callback(nil)
            }
        }
    }
}
