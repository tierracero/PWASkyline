//
//  Cust+BodegaNameAvalability.swift
//  
//
//  Created by Victor Cantu on 12/14/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustComponents {
    
    static func bodegaNameAvalability(
        storeId: UUID,
        bodegaId: UUID?,
        name: String,
        callback: @escaping ( (_ resp: APIResponseGeneric<BodegaNameAvalabilityResponse>?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "bodegaNameAvalability",
            BodegaNameAvalabilityRequest(
                storeId: storeId,
                bodegaId: bodegaId,
                name: name
            )
        ) { data in
            guard let data else{
                callback(nil)
                return
            }
            do{
                callback(try JSONDecoder().decode(APIResponseGeneric<BodegaNameAvalabilityResponse>.self, from: data))
            }
            catch{
                print("🔴 API_DECODING_ERROR")
                print(error)
                callback(nil)
            }
        }
    }
}
