//
//  CustOrder+LinkServiceOrderBudget.swift
//
//
//  Created by Victor Cantu on 12/6/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
import TCFundamentals

extension CustOrderEndpointV1 {
    
    static func linkServiceOrderBudget (
        budgetId: UUID,
        orderId: UUID,
        callback: @escaping ( (_ resp: APIResponse?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "linkServiceOrderBudget",
            LinkServiceOrderBudgetRequest(
                budgetId: budgetId,
                orderId: orderId
            )
        ) { resp in
            
            guard let data = resp else{
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
