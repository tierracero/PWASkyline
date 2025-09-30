//
//  Cust+SaveProductionElement.swift
//  
//
//  Created by Victor Cantu on 11/12/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustAPIEndpointV1 {
    
    static func getProductionElement (
        id: HybridIdentifier,
        callback: @escaping ( (_ resp: APIResponseGeneric<CustProductionElement>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "getProductionElement",
            GetProductionElementRequest(
                id: id
            )
        ) { data in
            guard let data else{
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<CustProductionElement>.self, from: data)
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
