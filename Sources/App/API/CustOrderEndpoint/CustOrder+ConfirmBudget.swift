//
//  CustOrder+ConfirmBudget.swift
//  
//
//  Created by Victor Cantu on 10/23/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustOrderComponents {
    
    static func confirmBudget (
        orderId: UUID,
        budgetId: UUID,
        callback: @escaping ( (_ resp: APIResponse?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "confirmBudget",
            ConfirmBudgetRequest(
                orderId: orderId,
                budgetId: budgetId
            )
        ) { data in
            guard let data else {
                callback(nil)
                return
            }
            do{
                let resp = try decodeAPIResponse(APIResponse.self, from: data)
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
