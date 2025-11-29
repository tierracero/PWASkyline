//
//  CustOrder+RemovePayment.swift
//  
//
//  Created by Victor Cantu on 7/9/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustOrderComponents {
    
    static func removePayment (
        orderId: UUID,
        orderFolio: String,
        paymentId: UUID,
        callback: @escaping ( (_ resp: APIResponseGeneric<RemovePaymentResponse>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "removePayment",
            RemovePaymentRequest(
                orderId: orderId,
                orderFolio: orderFolio,
                paymentId: paymentId
            )
        ) { resp in
            guard let data = resp else{
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<RemovePaymentResponse>.self, from: data)
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
