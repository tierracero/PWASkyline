//
//  Cust+SaveDocumentationArticle.swift
//  
//
//  Created by Victor Cantu on 6/15/24.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustComponents {
    
    static func saveDocumentationArticle(
        articleId: UUID,
        impact: CustDocumentationRuleImpact,
        name: String,
        description: String,
        tags: [String],
        suggestedProcedure: [String],
        callback: @escaping ((_ resp: APIResponse?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "saveDocumentationArticle",
            SaveDocumentationArticleRequest(
                articleId: articleId,
                impact: impact,
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
