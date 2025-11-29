//
//  CustOrder+LoadServiceOrderBudgets.swift
//  
//
//  Created by Victor Cantu on 12/6/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
import TCFundamentals

extension CustOrderComponents {
    
    static func loadServiceOrderBudgets (
        accountId: UUID,
        callback: @escaping ( (_ resp: APIResponseGeneric<[LoadServiceOrderBudgetsResponse]>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "loadServiceOrderBudgets",
            LoadServiceOrderBudgetsRequest(
                accountId: accountId
            )
        ) { data in
            
            guard let data else{
                callback(nil)
                return
            }
            
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<[LoadServiceOrderBudgetsResponse]>.self, from: data)
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
