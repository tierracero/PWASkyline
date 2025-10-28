//
//  Cust+SaveBodegaDetails.swift
//
//
//  Created by Victor Cantu on 7/5/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustAPIEndpointV1 {
    
    static func saveBodegaDetails(
        id: UUID,
        name: String,
        callback: @escaping ( (_ resp: APIResponseGeneric<SaveBodegaDetailsResponse>?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "saveBodegaDetails",
            SaveBodegaDetailsRequest(
                id: id,
                name: name
            )
        ) { data in
            
            guard let data else{
                callback(nil)
                return
            }
            
            do{
                callback(try JSONDecoder().decode(APIResponseGeneric<SaveBodegaDetailsResponse>.self, from: data))
            }
            catch{
                print("🔴 API_DECODING_ERROR")
                print(error)
                callback(nil)
            }
        }
    }
}
