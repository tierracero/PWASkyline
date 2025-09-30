//
//  Cust+CreateBodegaSection.swift
//  
//
//  Created by Victor Cantu on 12/14/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustAPIEndpointV1 {
    
    static func createBodegaSection(
        name: String,
        description: String,
        store: UUID,
        bodega: UUID,
        callback: @escaping ( (_ resp: APIResponseGeneric<CustStoreSeccionesSinc>?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "createBodegaSection",
            CreateBodegaSectionRequest(
                name: name,
                description: description,
                store: store,
                bodega: bodega
            )
        ) { payload in
            guard let data = payload else{
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<CustStoreSeccionesSinc>?.self, from: data)
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

