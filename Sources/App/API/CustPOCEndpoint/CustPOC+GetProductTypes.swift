//
//  CustPOC+GetProductTypes.swift
//
//
//  Created by Victor Cantu on 10/4/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustPOCEndpointV1 {
    
    static func getProductTypes(
        callback: @escaping ( (_ resp: APIResponseGeneric<[String]>?) -> () )
    ) {
        
        if !productTypeRefrence.isEmpty {
            callback(.init(status: .ok, data: productTypeRefrence))
        }
        
        sendPost(
            rout,
            version,
            "getProductTypes",
            EmptyPayload()
        ) { data in
            
            guard let data else{
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<[String]>.self, from: data)
                callback(resp)
            }
            catch{
                print(error)
                callback(nil)
            }
        }
    }
}
