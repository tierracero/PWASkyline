//
//  Cust+CreateSaleActionItem.swift
//  
//
//  Created by Victor Cantu on 4/4/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustComponents {
    
    static func createSaleActionItem(
        type: SaleActionType,
        id: UUID?,
        name: String,
        productionLevel: SaleActionDificultltyLevel,
        workforceLevel: SaleActionEmployeeLevel,
        productionTime: Int64,
        requestCompletition: Bool,
        operationalObject: [UUID],
        isFavorite: Bool,
        objects: [CustSaleActionObjectDecoder],
        callback: @escaping ( (_ resp: APIResponse?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "createSaleActionItem",
            CreateSaleActionItemRequest(
                type: type,
                id: id,
                name: name,
                productionLevel: productionLevel,
                workforceLevel: workforceLevel,
                productionTime: productionTime,
                requestCompletition: requestCompletition, 
                operationalObject: operationalObject,
                isFavorite: isFavorite,
                objects: objects
            )
        ) { payload in
            guard let data = payload else{
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

