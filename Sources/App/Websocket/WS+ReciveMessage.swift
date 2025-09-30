//
//  WS+ReciveMessage.swift
//  
//
//  Created by Victor Cantu on 8/12/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension WS {
    
    func reciveMessage(_ payload: String) -> API.wsV1.ReciveMessage? {
        
        if let data = payload.data(using: .utf8) {
            do {
                return try JSONDecoder().decode(API.wsV1.ReciveMessageNotification.self, from: data).payload
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
