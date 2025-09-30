//
//  WS+MetaNewMessengerPayload.swift
//  
//
//  Created by Victor Cantu on 4/19/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension WS {
    
    func metaNewMessengerPayload(_ payload: String) -> API.wsV1.MetaNewMessengerPayload? {
        
        if let data = payload.data(using: .utf8) {
            do {
                return try JSONDecoder().decode(API.wsV1.MetaNewMessengerPayloadNotification.self, from: data).payload
            }
            catch {
                
                print("⚡️   ⚡️   ⚡️   ⚡️   ⚡️   ⚡️   ⚡️   ⚡️   ⚡️   ⚡️   ⚡️   ⚡️   ")
                
                print(error)
                
                return nil
            }
        }
        else{
            return nil
        }
    }
}
