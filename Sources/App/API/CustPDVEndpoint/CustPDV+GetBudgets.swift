//
//  CustPDV+GetBudgets.swift
//  
//
//  Created by Victor Cantu on 5/25/26.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustPDVComponents {
    
    static func getBudgets(
        callback: @escaping ((
            _ resp: APIResponseGeneric<[GetBudgetsObjeto]>?
        ) -> ())
    ) {
        
        sendPost(
            rout,
            version,
            "getBudgets",
            EmptyPayload()
        ) { data in

            guard let data else {
                callback(nil)
                return
            }
        
            do{
                callback(try JSONDecoder().decode(APIResponseGeneric<[GetBudgetsObjeto]>.self, from: data))
            }
            catch{
                print(error)
                callback(nil)
            }
        
        }
    }    
}
                