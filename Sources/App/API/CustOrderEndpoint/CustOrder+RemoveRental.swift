//
//  CustOrder+RemoveRental.swift
//  
//
//  Created by Victor Cantu on 7/13/22.
//


import Foundation
import TCFundamentals
import TCFireSignal

extension CustOrderEndpointV1 {
    
    static func removeRental (
        orderId: UUID,
        orderFolio: String,
        itemId: UUID,
        callback: @escaping ( (_ resp: APIResponseGeneric<RemoveRentalResponse>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "removeRental",
            RemoveRentalRequest(
                orderId: orderId,
                orderFolio: orderFolio,
                itemId: itemId
            )
        ) { resp in
            guard let data = resp else{
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<RemoveRentalResponse>.self, from: data)
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
