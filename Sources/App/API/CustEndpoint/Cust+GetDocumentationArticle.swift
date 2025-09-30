//
//  Cust+GetDocumentationArticle.swift
//
//
//  Created by Victor Cantu on 6/15/24.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustAPIEndpointV1 {
    
    static func getDocumentationArticle(
        articleId: UUID,
        callback: @escaping ( (_ resp: APIResponseGeneric<GetDocumentationArticleResponse>?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "getDocumentationArticle",
            GetDocumentationArticleRequest(
                articleId: articleId
            )
        ) { data in
            guard let data else{
                callback(nil)
                return
            }
            do{
                callback(try JSONDecoder().decode(APIResponseGeneric<GetDocumentationArticleResponse>.self, from: data))
            }
            catch{
                print("🔴 API_DECODING_ERROR")
                print(error)
                callback(nil)
            }
        }
    }
}
