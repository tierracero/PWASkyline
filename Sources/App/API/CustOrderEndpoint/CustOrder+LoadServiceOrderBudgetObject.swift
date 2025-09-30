//
//  CustOrder+LoadServiceOrderBudgetObject.swift
//  
//
//  Created by Victor Cantu on 8/29/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustOrderEndpointV1 {
    
    static func loadServiceOrderBudgetObject(
        orderid: UUID,
        callback: @escaping ( (_ resp: APIResponseGeneric<API.custOrderV1.LoadServiceOrderBudgetsResponse>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "loadServiceOrderBudgetObject",
            API.custOrderV1.LoadServiceOrderBudgetObjectRequest(
                orderid: orderid
            )
        ) { payload in
            
            guard let data = payload else{
                callback(nil)
                return
            }
            
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<API.custOrderV1.LoadServiceOrderBudgetsResponse>.self, from: data)
                callback(resp)
            }
            catch{
                print(error)
                callback(nil)
            }
        }
    }
}
