//
//  CustPOC+GetPOCCost.swift
//  
//
//  Created by Victor Cantu on 7/8/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustPOCComponents {
    
    static func getPOCCost(
        id: UUID,
        callback: @escaping ( (_ resp: APIResponseGeneric<Int64>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "getPOCCost",
            GetPOCCostRequest(
                id: id
            )
        ) { payload in
            guard let payload else{
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<Int64>.self, from: payload)
                callback(resp)
            }
            catch{
                print(error)
                callback(nil)
            }
        }
    }
}


