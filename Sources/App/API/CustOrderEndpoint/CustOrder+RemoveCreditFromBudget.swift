//
//  CustOrder+RemoveCreditFromBudget.swift
//  
//
//  Created by Victor Cantu on 6/28/24.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustOrderEndpointV1 {
    
    static func removeCreditFromBudget (
        budgetId: UUID,
        callback: @escaping ( (_ resp: APIResponse?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "removeCreditFromBudget",
            RemoveCreditFromBudgetRequest(
                budgetId: budgetId
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
