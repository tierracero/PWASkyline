//
//  WS+SendToMobile.swift
//  
//
//  Created by Victor Cantu on 5/9/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension WS {
    
    func sendToMobile(_ payload: String) -> API.custAPIV1.SendToMobileRequest? {
        
        if let data = payload.data(using: .utf8) {
            do {
                return try JSONDecoder().decode(API.wsV1.WebSocketPayload<API.custAPIV1.SendToMobileRequest>.self, from: data).payload
            } catch {
                print(error)
                return nil
            }
        }
        else{
            return nil
        }
    }
    
}

