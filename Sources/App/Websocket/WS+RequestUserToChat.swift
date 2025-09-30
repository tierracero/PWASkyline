//
//  WS+RequestUserToChat.swift
//  
//
//  Created by Victor Cantu on 8/19/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension WS {
    
    func requestUserToChat(_ payload: String) -> API.wsV1.RequestUserToChatResponse? {
        
        if let data = payload.data(using: .utf8) {
            do {
                return try JSONDecoder().decode(API.wsV1.WebSocketPayload<API.wsV1.RequestUserToChatResponse>.self, from: data).payload
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

