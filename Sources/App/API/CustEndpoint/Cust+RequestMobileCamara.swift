//
//  Cust+RequestMobileCamara.swift
//  
//
//  Created by Victor Cantu on 5/2/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustAPIEndpointV1 {
    
    static func requestMobileCamara(
        type: APNSNotificationType,
        connid: String,
        eventid: UUID,
        relatedid: UUID?,
        relatedfolio: String,
        multipleTakes: Bool,
        callback: @escaping ( (_ resp: APIResponse?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "requestMobileCamara",
            RequestMobileCamaraRequst(
                type: type,
                connid: connid,
                eventid: eventid,
                relatedid: relatedid,
                relatedfolio: relatedfolio,
                multipleTakes: multipleTakes
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
                print(error)
                callback(nil)
            }
        }
    }
}

