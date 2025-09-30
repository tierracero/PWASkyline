//
//  WS+Pong.swift
//
//
//  Created by Victor Cantu on 1/26/25.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension WS {
    
    func pong(_ payload: String) -> API.wsV1.PongNotification? {
        
        if let data = payload.data(using: .utf8) {
            do {
                return try JSONDecoder().decode(API.wsV1.PongNotification.self, from: data)
            } catch {
                return nil
            }
        }
        else{
            return nil
        }
    }
}
