//
//  CustOrder+AddCreditToBudget.swift
//
//
//  Created by Victor Cantu on 6/24/24.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustOrderComponents {
    
    static func addCreditToBudget (
        budgetId: UUID,
        credit: Int64,
        expireAt: Int64,
        callback: @escaping ( (_ resp: APIResponse?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "addCreditToBudget",
            AddCreditToBudgetRequest(
                budgetId: budgetId,
                credit: credit,
                expireAt: expireAt
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
