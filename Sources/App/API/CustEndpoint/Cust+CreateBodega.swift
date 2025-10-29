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
        bodegaName: String,
        bodegaDescription: String,
        sectionName: String,
        relationType: CreateBodegaRelationType,
        callback: @escaping ( (_ resp: APIResponseGeneric<CreateBodegaResponse>?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "createBodega",
            CreateBodegaRequest(
                bodegaName: bodegaName,
                bodegaDescription: bodegaDescription,
                sectionName: sectionName,
                relationType: relationType
            )
        ) { data in
            guard let data else{
                callback(nil)
                return
            }
            do{
                callback(try JSONDecoder().decode(APIResponseGeneric<CreateBodegaResponse>?.self, from: data))
            }
            catch{
                print("🔴 API_DECODING_ERROR")
                print(error)
                callback(nil)
            }
        }
    }
}

