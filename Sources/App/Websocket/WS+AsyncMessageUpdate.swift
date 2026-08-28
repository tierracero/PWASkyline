//
//  WS+AsyncMessageUpdate.swift
//
//
//  Created by Victor Cantu on 10/7/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension WS {

    func asyncFileUpload(_ payload: String) -> API.webSocketV1.AsyncMessageUpdate? {
        
        guard let data = payload.data(using: .utf8) else {
            return nil
        }

        do {
            return try JSONDecoder().decode(API.webSocketV1.AsyncMessageUpdateNotification.self, from: data).payload
        } catch {
            
            print("🔴   WS DECODE")

            print(error)
            
            return nil
        }
    }
}

