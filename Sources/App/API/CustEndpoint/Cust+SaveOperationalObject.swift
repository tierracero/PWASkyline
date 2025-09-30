//
//  Cust+SaveOperationalObject.swift
//
//
//  Created by Victor Cantu on 11/12/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustAPIEndpointV1 {
    
    static func saveOperationalObject (
        id: UUID?,
        productionElement: UUID?,
        productionUnits: Int64,
        productionCost: Int64,
        productionTime: Int64,
        productionLevel: SaleActionEmployeeLevel,
        isFavorite: Bool,
        code: String,
        name: String,
        description: String,
        callback: @escaping ( (_ resp: APIResponseGeneric<CustSOCActionOperationalObjectQuick>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "saveOperationalObject",
            SaveOperationalObjectRequest(
                id: id,
                productionElement: productionElement,
                productionUnits: productionUnits,
                productionCost: productionCost,
                productionTime: productionTime, 
                productionLevel: productionLevel,
                isFavorite: isFavorite,
                code: code,
                name: name,
                description: description
            )
        ) { data in
            guard let data else{
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<CustSOCActionOperationalObjectQuick>.self, from: data)
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
