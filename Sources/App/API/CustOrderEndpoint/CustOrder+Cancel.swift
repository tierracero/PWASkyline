//
//  CustOrder+Cancel.swift
//
//
//  Created by Victor Cantu on 7/24/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustOrderEndpointV1 {
    static func cancel (
        orderid: UUID,
        equipments: [FinalizeEquipment],
        rentals: [RentalEquipment],
        sendComm: Bool,
        lastCommunicationMethod: MessagingCommunicationMethods?,
        callback: @escaping ( (_ resp: APIResponseGeneric<FinalizeResponse>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "cancel",
            FinalizeRequest(orderid: orderid, equipments: equipments, rentals: rentals, sendComm: true, lastCommunicationMethod: lastCommunicationMethod)
        ) { resp in
            guard let data = resp else{
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<FinalizeResponse>.self, from: data)
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
