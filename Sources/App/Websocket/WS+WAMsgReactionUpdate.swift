//
//  WS+WAMsgReactionUpdate.swift
//
//
//  Created by Victor Cantu on 4/25/24.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension WS {
    func waMsgReactionUpdate(_ payload: String) -> API.webSocketV1.MsgReactionUpdateUpdate? {
        
        if let data = payload.data(using: .utf8) {
            do {
                return try JSONDecoder().decode(API.webSocketV1.MsgReactionUpdateNotification.self, from: data).payload
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


