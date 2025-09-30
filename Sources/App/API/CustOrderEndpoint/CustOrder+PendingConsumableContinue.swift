//
//  CustOrder+PendingConsumableContinue.swift
//  
//
//  Created by Victor Cantu on 10/18/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustOrderEndpointV1 {
    
    static func pendingConsumableContinue (
        hasPurchase: Bool,
        orderId: UUID,
        equipmentId: UUID,
        managerId: UUID,
        vendorId: UUID?,
        documentId: UUID?,
        documentFolio: String,
        comment: String,
        sendComm: Bool,
        lastCommunicationMethod: MessagingCommunicationMethods?,
        callback: @escaping ( (
            _ resp: APIResponseGeneric<PendingConsumableContinueResponse>?
        ) -> () )
    ) {
        sendPost(
            rout,
            version,
            "pendingConsumableContinue",
            PendingConsumableContinueRequest(
                hasPurchase: hasPurchase,
                orderId: orderId,
                equipmentId: equipmentId,
                managerId: managerId,
                vendorId: vendorId,
                documentId: documentId,
                documentFolio: documentFolio,
                comment: comment,
                sendComm: sendComm,
                lastCommunicationMethod: lastCommunicationMethod
            )
        ) { resp in
            guard let data = resp else{
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<PendingConsumableContinueResponse>.self, from: data)
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

