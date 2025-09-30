//
//  CustOrder+ApproveBudget.swift
//  
//
//  Created by Victor Cantu on 10/14/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustOrderEndpointV1 {
    
    static func approveBudget (
        id: UUID,
        callback: @escaping ( (_ resp: APIResponseGeneric<ApproveBudgetResponse>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "approveBudget",
            APIRequestID(id: id, store: custCatchStore)
        ) { resp in
            guard let data = resp else{
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<ApproveBudgetResponse>.self, from: data)
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

