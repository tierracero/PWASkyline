//
//  CustPOC+AddBrands.swift
//  
//
//  Created by Victor Cantu on 9/18/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustPOCEndpointV1 {
    
    static func addBrands(
        brand: String,
        callback: @escaping ( (_ resp: APIResponseGeneric<AddBrandsResponse>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "addBrands",
            AddBrandsRequest(
                brand: brand
            )
        ) { payload in
            guard let data = payload else{
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<AddBrandsResponse>.self, from: data)
                callback(resp)
            }
            catch{
                print(error)
                callback(nil)
            }
        }
    }
}
