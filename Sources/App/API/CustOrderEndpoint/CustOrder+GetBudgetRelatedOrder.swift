//
//  CustOrder+GetBudgetRelatedOrder.swift
//
//
//  Created by Victor Cantu on 10/23/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustOrderComponents {
    
    static func getBudgetRelatedOrder (
        budgetId: UUID,
        callback: @escaping ( (_ resp: APIResponseGeneric<GetBudgetRelatedOrderResponse>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "getBudgetRelatedOrder",
            GetBudgetRelatedOrderRequest(
                budgetId: budgetId
            )
        ) { data in
            guard let data else{
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<GetBudgetRelatedOrderResponse>.self, from: data)
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
