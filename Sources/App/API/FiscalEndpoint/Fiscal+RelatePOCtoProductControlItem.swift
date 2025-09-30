//
//  Fiscal+RelatePOCtoProductControlItem.swift
//  
//
//  Created by Victor Cantu on 2/11/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension FiscalEndpointV1 {
    
    static func relatePOCtoProductControlItem(
        productContolId: UUID,
        vendorId: UUID,
        vendorRfc: String,
        pocid: UUID,
        name: String,
        brand: String,
        model: String,
        upc: String,
        callback: @escaping ( (_ resp: APIResponse?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "relatePOCtoProductControlItem",
            RelatePOCtoProductControlItemRequest(
                productContolId: productContolId,
                vendorId: vendorId,
                vendorRfc: vendorRfc,
                pocid: pocid,
                name: name,
                brand: brand,
                model: model,
                upc: upc
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
                print(error)
                callback(nil)
            }
        }
        
    }
}

