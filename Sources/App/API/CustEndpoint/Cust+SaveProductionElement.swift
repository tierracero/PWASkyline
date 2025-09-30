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
    
    static func saveProductionElement (
        id: UUID?,
        code: String,
        name: String,
        description: String,
        cost: Int64,
        isFavorite: Bool,
        callback: @escaping ( (_ resp: APIResponseGeneric<CustProductionElement>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "saveProductionElement",
            SaveProductionElementRequest(
                id: id,
                code: code,
                name: name,
                description: description,
                cost: cost,
                isFavorite: isFavorite
            )
        ) { resp in
            guard let data = resp else{
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
