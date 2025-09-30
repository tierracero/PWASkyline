//
//  Cust+SendToMobile.swift
//  
//
//  Created by Victor Cantu on 5/9/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustAPIEndpointV1 {
        
    static func sendToMobile(
        type: APNSNotificationType,
        targetUser: String,
        objid: UUID,
        smallDescription: String,
        description: String,
        callback: @escaping ( (_ resp: APIResponse?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "sendToMobile",
            SendToMobileRequest(
                type: type,
                targetUser: targetUser,
                objid: objid,
                smallDescription: smallDescription,
                description: description
            )
        ) { payload in
            
            guard let data = payload else{
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
