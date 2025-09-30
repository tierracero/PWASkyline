//
//  CustOrder+RequestBudget.swift
//
//
//  Created by Victor Cantu on 10/23/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustOrderEndpointV1 {
    
    @available(*, deprecated, message: "Replace by Cust+RequestTask")
    static func requestBudget (
        orderId: UUID,
        storeId: UUID,
        comment: String,
        callback: @escaping ( (_ resp: APIResponseGeneric<RequestBudgetResponse>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "requestBudget",
            RequestBudgetRequest(
                orderId: orderId,
                storeId: storeId,
                comment: comment
            )
        ) { resp in
            guard let data = resp else{
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<RequestBudgetResponse>.self, from: data)
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
