//
//  CustOrder+EditBudgetObject.swift
//  
//
//  Created by Victor Cantu on 2/10/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustOrderComponents {
    
    static func editBudgetObject(
        orderid: UUID,
        budgetid: UUID,
        objectid: UUID,
        units: Int64,
        unitCost: Int64,
        name: String,
        callback: @escaping ( (_ resp: APIResponse?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "editBudgetObject",
            EditBudgetObjectRequest(
                orderid: orderid,
                budgetid: budgetid,
                objectid: objectid,
                units: units,
                unitCost: unitCost,
                name: name
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
