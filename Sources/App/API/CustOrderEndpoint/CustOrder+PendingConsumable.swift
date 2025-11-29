//
//  CustOrder+PendingConsumable.swift
//  
//
//  Created by Victor Cantu on 10/18/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustOrderComponents {
    
    static func pendingConsumable (
        orderid: UUID,
        equipmentid: UUID,
        days: Int,
        description: String,
        reason: String,
        sendComm: Bool,
        lastCommunicationMethod: MessagingCommunicationMethods?,
        callback: @escaping ( (_ resp: APIResponseGeneric<PendingConsumableResponse>?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "pendingConsumable",
            PendingConsumableRequest(
                orderid: orderid,
                equipmentid: equipmentid,
                days: days,
                description: description,
                reason: reason,
                sendComm: sendComm,
                lastCommunicationMethod: lastCommunicationMethod
            )
        ) { resp in
            guard let data = resp else{
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<PendingConsumableResponse>.self, from: data)
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

