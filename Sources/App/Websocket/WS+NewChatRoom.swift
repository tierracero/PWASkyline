//
//  WS+NewChatRoom.swift
//  
//
//  Created by Victor Cantu on 8/10/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension WS {
    func newChatRoom(_ payload: String) -> API.webSocketV1.NewChatRoom? {
        
        if let data = payload.data(using: .utf8) {
            do {
                return try JSONDecoder().decode(API.webSocketV1.NewChatRoomNotification.self, from: data).payload
            } catch {
                return nil
            }
        }
        else{
            return nil
        }
    }
}
