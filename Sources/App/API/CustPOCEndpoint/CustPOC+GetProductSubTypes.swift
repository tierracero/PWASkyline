//
//  CustPOC+GetProductSubTypes.swift
//
//
//  Created by Victor Cantu on 10/4/23.
//
import Foundation
import TCFundamentals
import TCFireSignal

extension CustPOCComponents {
    
    static func getProductSubTypes(
        productType: String,
        callback: @escaping ( (_ resp: APIResponseGeneric<[String]>?) -> () )
    ) {
        
        if let refrence = productSubTypeRefrence[productType] {
            callback(.init(status: .ok, data: refrence))
        }
        
        sendPost(
            rout,
            version,
            "getProductSubTypes",
            GetProductSubTypesRequest(
                productType: productType
            )
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
