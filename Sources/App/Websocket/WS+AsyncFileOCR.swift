//
//  WS+AsyncFileOCR.swift
//  
//
//  Created by Victor Cantu on 2/4/25.
//

import Foundation
import Foundation
import TCFundamentals
import TCFireSignal

extension WS {
    func asyncFileOCR(_ payload: String) -> API.webSocketV1.AsyncFileOCR? {
        
        if let data = payload.data(using: .utf8) {
            do {
                return try JSONDecoder().decode(API.webSocketV1.AsyncFileOCRNotification.self, from: data).payload
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