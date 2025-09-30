//
//  CustOrder+RemoveCharge.swift
//  
//
//  Created by Victor Cantu on 7/9/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustOrderEndpointV1 {
    
    static func removeCharge (
        orderId: UUID,
        orderFolio: String,
        chargeId: UUID,
        callback: @escaping ( (_ resp: APIResponseGeneric<RemoveChargeResponse>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "removeCharge",
            RemoveChargeRequest(
                orderId: orderId,
                orderFolio: orderFolio,
                chargeId: chargeId
            )
        ) { data in
            guard let data else{
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<RemoveChargeResponse>.self, from: data)
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
