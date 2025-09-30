//
//  API+JWT.swift
//  
//
//  Created by Victor Cantu on 11/7/24.
//

import Foundation
import TCFundamentals
import TCFireSignal
import XMLHttpRequest
import Web

extension APIEndpointV1 {
    
    static func jwt(callback: @escaping ( (_ resp: String?) -> () )){
        
        let xhr = XMLHttpRequest()
        
        // let url = "https://intratc.co/api/jwt/control.\(custCatchUrl)"
        
        let url = "https://intratc.co/api/jwt/\(WebApp.shared.window.location.hostname)"
        
        print(url)
        
        xhr.open(method: "GET", url: url)
        
        xhr.send()
        
        xhr.onError {
            print("error")
            print(xhr.responseText ?? "")
            callback(nil)
        }
        xhr.onLoad {
            callback(xhr.responseText)
        }
        
    }
}
