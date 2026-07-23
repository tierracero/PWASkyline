//
//  WS+Welcome.swift
//  
//
//  Created by Victor Cantu on 8/7/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension WS {
    
    func welcome(_ payload: String) -> API.webSocketV1.WSWelcome? {
        
        if let data = payload.data(using: .utf8) {
            do {
                return try JSONDecoder().decode(API.webSocketV1.WSWelcome.self, from: data)
            } catch {
                return nil
            }
        }
        else{
            return nil
        }
    }
}
