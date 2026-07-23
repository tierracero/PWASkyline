//
//  CustComertialTrips+RemoveCharge.swift
//  
//
//  Created by Victor Cantu on 7/9/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustCommercialTripsComponents {
    
    static func removeCharge (
        tripId: UUID,
        orderFolio: String,
        chargeId: UUID,
        callback: @escaping ( (_ resp: APIResponseGeneric<RemoveChargeResponse>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "removeCharge",
            RemoveChargeRequest(
                tripId: tripId,
                orderFolio: orderFolio,
                chargeId: chargeId
            )
        ) { data in
            guard let data else{
                callback(nil)
                return
            }
            do{
                let resp = try decodeAPIResponse(APIResponseGeneric<RemoveChargeResponse>.self, from: data)
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
