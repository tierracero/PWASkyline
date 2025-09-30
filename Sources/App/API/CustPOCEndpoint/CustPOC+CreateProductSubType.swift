//
//  CustPOC+CreateProductSubType.swift
//  
//
//  Created by Victor Cantu on 10/4/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustPOCEndpointV1 {
    
    static func createProductSubType(
        productType: String,
        productSubType: String,
        callback: @escaping ( (_ resp: APIResponse?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "createProductSubType",
            CreateProductSubTypeRequest(
                productType: productType,
                productSubType: productSubType
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

