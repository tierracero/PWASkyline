//
//  CustPOC+ChangePriceInConcesion.swift
//
//
//  Created by Victor Cantu on 1/20/24.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustPOCEndpointV1 {
    
    static func changePriceInConcesion(
        itemId: UUID,
        newPrice: Int64,
        reason: String,
        callback: @escaping ( (_ resp: APIResponseGeneric<CustGeneralNotesQuick>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "changePriceInConcesion",
            ChangePriceInConcesionRequest(
                itemId: itemId,
                newPrice: newPrice,
                reason: reason
            )
        ) { data in
            guard let data  else{
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<CustGeneralNotesQuick>.self, from: data)
                callback(resp)
            }
            catch{
                print(error)
                callback(nil)
            }
        }
        
    }
}

