//
//  Cust+GetProductionElements.swift
//
//
//  Created by Victor Cantu on 11/12/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustComponents {
    
    static func getProductionElements (
        callback: @escaping ( (_ resp: APIResponseGeneric<GetProductionElementsResponse>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "getProductionElements",
            EmptyPayload()
        ) { resp in
            guard let data = resp else{
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<GetProductionElementsResponse>.self, from: data)
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
