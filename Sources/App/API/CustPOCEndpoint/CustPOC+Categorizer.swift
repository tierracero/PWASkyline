//
//  CustPOC+Categorizer.swift
//  
//
//  Created by Victor Cantu on 10/5/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustPOCEndpointV1 {
    
    static func categorizer(
        store: CategorizerStores,
        productType: String,
        productSubType: String,
        brand: String,
        model: String,
        name: String,
        callback: @escaping ( (_ resp: APIResponseGeneric<CategorizerResponse>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "categorizer",
            CategorizerRequest(
                store: store,
                productType: productType,
                productSubType: productSubType,
                brand: brand,
                model: model,
                name: name
            )
        ) { payload in
            guard let data = payload else{
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<CategorizerResponse>.self, from: data)
                callback(resp)
            }
            catch{
                print(error)
                callback(nil)
            }
        }
    }
}

