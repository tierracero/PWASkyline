//
//  WS+ConfirmSentMessage.swift
//  
//
//  Created by Victor Cantu on 4/24/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension WS {
    func confirmSentMessage(_ payload: String) -> API.wsV1.ConfirmSentMessageRequest? {
        
        if let data = payload.data(using: .utf8) {
            do {
                return try JSONDecoder().decode(API.wsV1.WebSocketPayload<API.wsV1.ConfirmSentMessageRequest>.self, from: data).payload
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



