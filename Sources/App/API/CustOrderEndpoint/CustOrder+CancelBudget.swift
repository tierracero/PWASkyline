//
//  CustOrder+CancelBudget.swift
//  
//
//  Created by Victor Cantu on 10/23/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustOrderComponents {
    
    static func cancelBudget (
        orderId: UUID,
        budgetId: UUID,
        callback: @escaping ( (_ resp: APIResponse?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "cancelBudget",
            CancelBudgetRequest(
                orderId: orderId,
                budgetId: budgetId
            )
        ) { data in
            guard let data else{
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponse.self, from: data)
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
