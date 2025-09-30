//
//  Cust+ChangeDocumentationRuleFavoriteStatus.swift
//
//
//  Created by Victor Cantu on 6/15/24.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustAPIEndpointV1 {
    
    static func changeDocumentationRuleFavoriteStatus(
        ruleId: UUID,
        favorite: Bool,
        callback: @escaping ( (_ resp: APIResponseGeneric<GetDocumentationRulesResponse>?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "changeDocumentationRuleFavoriteStatus",
            ChangeDocumentationRuleFavoriteStatusRequest(
                ruleId: ruleId,
                favorite: favorite
            )
        ) { data in
            guard let data else{
                callback(nil)
                return
            }
            do{
                callback(try JSONDecoder().decode(APIResponseGeneric<GetDocumentationRulesResponse>?.self, from: data))
            }
            catch{
                print("🔴 API_DECODING_ERROR")
                print(error)
                callback(nil)
            }
        }
    }
}
