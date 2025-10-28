//
//  Cust+CreateBodega.swift
//  
//
//  Created by Victor Cantu on 7/4/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustAPIEndpointV1 {
    
    static func createBodega(
        name: String,
        description: String,
        storeId: UUID,
        suportsSections: Bool,
        callback: @escaping ( (_ resp: APIResponseGeneric<CustStoreBodegas>?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "createBodega",
            CreateBodegaRequest(
                name: name,
                description: description,
                storeId: storeId,
                suportsSections: suportsSections
            )
        ) { data in
            guard let data else{
                callback(nil)
                return
            }
            do{
                callback(try JSONDecoder().decode(APIResponseGeneric<CustStoreBodegas>?.self, from: data))
            }
            catch{
                print("🔴 API_DECODING_ERROR")
                print(error)
                callback(nil)
            }
        }
    }
}

