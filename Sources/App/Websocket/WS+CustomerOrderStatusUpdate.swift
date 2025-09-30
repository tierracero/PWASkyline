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
    
    func customerOrderStatusUpdate(_ payload: String) -> API.wsV1.CustomerOrderStatusUpdate? {
        
        if let data = payload.data(using: .utf8) {
            do {
                return try JSONDecoder().decode(API.wsV1.WebSocketPayload<API.wsV1.CustomerOrderStatusUpdate>.self, from: data).payload
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
