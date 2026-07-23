//
//  WS+CustomerOrderStatusUpdate.swift
//  
//
//  Created by Victor Cantu on 5/9/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension WS {
    
    func customerOrderStatusUpdate(_ payload: String) -> API.webSocketV1.CustomerOrderStatusUpdate? {
        
        if let data = payload.data(using: .utf8) {
            do {
                return try JSONDecoder().decode(API.webSocketV1.WebSocketPayload<API.webSocketV1.CustomerOrderStatusUpdate>.self, from: data).payload
            }
            catch {
                print(error)
                return nil
            }
        }
        else{
            return nil
        }
    }
    
}
