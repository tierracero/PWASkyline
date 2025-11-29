//
// Cust+GetBodegaDetails.swift
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustComponents {
        
    static func getBodegaDetails(
        bodegaId: UUID,
        callback: @escaping ( (_ resp: APIResponseGeneric<GetBodegaDetailsResponse>?) -> () )
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
                
                callback( try JSONDecoder().decode(APIResponseGeneric<GetBodegaDetailsResponse>.self, from: data) )
                
            }
            catch {
                callback(nil)
            }
        }
    }
}
