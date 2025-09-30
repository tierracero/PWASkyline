//
//  Cust+NotificationsSaveSettings.swift
//  
//
//  Created by Victor Cantu on 4/28/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustAPIEndpointV1 {
        
    static func notificationsSaveSettings(
        frequency: CustTaskAuthorizationManagerAlertFrequency,
        level: CustTaskAuthorizationManagerAlertLevel,
        callback: @escaping ( (_ resp: APIResponse?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "notificationsSaveSettings",
            NotificationsSaveSettingsRequest(
                frequency: frequency,
                level: level
            )
        ) { data in
            
            guard let data else {
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

