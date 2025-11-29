//
//  CustOrder+Update.swift
//  
//
//  Created by Victor Cantu on 7/23/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustOrderComponents {
    
    static func update (
        orderid: UUID,
        uts: Int64,
        sendComm: Bool,
        lastCommunicationMethod: MessagingCommunicationMethods?,
        callback: @escaping ( (_ resp: APIResponse?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "update",
            UpdateRequest(
                orderid: orderid,
                uts: uts,
                sendComm: sendComm,
                lastCommunicationMethod: lastCommunicationMethod
            )
        ) { resp in
            guard let data = resp else{
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponse.self, from: data)
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

