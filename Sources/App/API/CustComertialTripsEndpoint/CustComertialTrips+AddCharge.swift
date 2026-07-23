//
//  CustComertialTrips+AddCharge.swift
//
//
//  Created by Victor Cantu on 7/9/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustCommercialTripsComponents {
    
    ///  Send OrderID to retive notes
    static func addCharge (
        tripId: UUID,
        item: AddChargeType,
        callback: @escaping ((
            _ resp: APIResponseGeneric<API.custCommercialTrips.AddChargeResponse>?
        ) -> ())
    ) {
        sendPost(
            rout,
            version,
            "addCharge",
            AddChargeRequest(
                 tripId: tripId,
                item: item
            )
        ) { data in
            
            guard let data else {
                
                callback(nil)
                return
            }
            do{
                callback(try decodeAPIResponse(
                    APIResponseGeneric<API.custCommercialTrips.AddChargeResponse>.self,
                    from: data
                ))
            }
            catch{
                print("🔴 API_DECODING_ERROR")
                print(error)
                callback(nil)
            }
        }
        
    }
}
