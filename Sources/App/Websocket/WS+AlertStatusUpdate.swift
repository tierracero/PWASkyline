//
//  WS+AlertStatusUpdate.swift
//  
//
//  Created by Victor Cantu on 8/14/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension WS {
    func alertStatusUpdate(_ payload: String) -> API.wsV1.AlertStatusUpdate? {
        
        if let data = payload.data(using: .utf8) {
            do {
                return try JSONDecoder().decode(API.wsV1.AlertStatusUpdateNotification.self, from: data).payload
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
