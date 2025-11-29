//
//  CustOrder+SendServiceOrder.swift
//  
//
//  Created by Victor Cantu on 7/24/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustOrderComponents {
    
    static func sendServiceOrder (
        orderId: UUID,
        callback: @escaping ( (_ resp: APIResponseGeneric<SendServiceOrderResponse>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "sendServiceOrder",
            SendServiceOrderRequest(
                orderId: orderId
            )
            
        ) { data in

            guard let data else{
                callback(nil)
                return
            }
            do{
                callback(try JSONDecoder().decode(APIResponseGeneric<SendServiceOrderResponse>.self, from: data))
            }
            catch{
                print("🔴 API_DECODING_ERROR")
                print(error)
                callback(nil)
            }
        }
        
    }
    
}

