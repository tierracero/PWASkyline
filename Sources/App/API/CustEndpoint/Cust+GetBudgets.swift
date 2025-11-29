//
//  Cust+GetBudgets.swift
//  
//
//  Created by Victor Cantu on 3/28/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustComponents {
        
    static func getBudgets(
        id: UUID,
        callback: @escaping ( (_ resp: [GetBudgetsObjeto]) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "getBudgets",
            APIRequestID(id: id, store: nil)
        ) { payload in
            
            guard let data = payload else{
                callback([])
                return
            }
            
            do{
                
                let resp = try JSONDecoder().decode(APIResponseGeneric<[GetBudgetsObjeto]>.self, from: data)
                
                guard let data = resp.data else {
                    callback([])
                    return
                }
                
                callback(data)
                
            }
            catch {
                
                callback([])
            }
            
        }
    }
}
