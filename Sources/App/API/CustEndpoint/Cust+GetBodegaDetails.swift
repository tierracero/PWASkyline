//
// Cust+GetBodegaDetails.swift
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustAPIEndpointV1 {
        
    static func getBodegaDetails(
        bodegaId: UUID,
        callback: @escaping ( (_ resp: APIResponseGeneric<GetBodegaDetailsRequest>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "getBodegaDetails",
            GetBodegaDetailsRequest(
                bodegaId: bodegaId
            )
        ) { data in
            
            guard let data  else {
                callback(nil)
                return
            }
            
            do{
                
                callback( try JSONDecoder().decode(APIResponseGeneric<GetBodegaDetailsRequest>.self, from: data) )
                
            }
            catch {
                callback(nil)
            }
        }
    }
}
