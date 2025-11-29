//
//  API+ReportError.swift
//  
//
//  Created by Victor Cantu on 10/19/22.
//

import TCFundamentals
import Foundation
import TCFundamentals
import TCFireSignal
import Web

extension APIComponents {
    
    static func reportError(
        errorTitle: String,
        error: String,
        callback: @escaping ( (_ resp: APIResponse?) -> () )
    ) {
        
        let appid: AppIDNotificationRefrence? = nil
        let type: String = "web"
        let token: String = custCatchToken
        let username: String = custCatchUser
        let device: String = WebApp.current.window.navigator.userAgent
        
        sendPost(
            rout,
            version,
            "reportError",
            ReportErrorRequest(
                appid: appid,
                type: type,
                token: token,
                username: username,
                device: device,
                errorTitle: errorTitle,
                error: error
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

