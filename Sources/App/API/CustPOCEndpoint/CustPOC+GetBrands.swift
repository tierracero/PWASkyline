//
//  CustPOC+GetBrands.swift
//  
//
//  Created by Victor Cantu on 9/18/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustPOCEndpointV1 {
    
    static func getBrands(
        callback: @escaping ( (_ resp: APIResponseGeneric<[CustBrands]>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "getBrands",
            EmptyPayload()
        ) { payload in
            guard let data = payload else{
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<[CustBrands]>.self, from: data)
                callback(resp)
            }
            catch{
                print(error)
                callback(nil)
            }
        }
    }
}
