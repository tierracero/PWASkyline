//
//  CustOrder+CreateBudgetObject.swift
//  
//
//  Created by Victor Cantu on 10/13/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustOrderComponents {
    
    static func createBudgetObject(
        budgetId: UUID?,
        orderId: UUID,
        comment: String,
        store: UUID,
        saleType: FolioTypes,
        objects: [CreateBudgetObject],
        callback: @escaping ( (_ resp: APIResponseGeneric<CreateBudgetObjectleResponse>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "createBudgetObject",
            CreateBudgetObjectleRequest(
                budgetId: budgetId,
                orderId: orderId,
                comment: comment,
                store: store,
                saleType: saleType,
                objects: objects
            )
        ) { data in
            
            guard let data else{
                callback(nil)
                return
            }
            
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<CreateBudgetObjectleResponse>.self, from: data)
                callback(resp)
            }
            catch{
                
                print("🔴  DECODING ERROR  🔴")
                
                print(error)
                
                callback(nil)
            }
            
        }
    }
    
}

