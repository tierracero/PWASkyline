//
//  WS+WAMsgStatusUpdate.swift
//  
//
//  Created by Victor Cantu on 8/16/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension WS {
    func waMsgStatusUpdate(_ payload: String) -> API.wsV1.WSMsgStatusUpdate? {
        
        if let data = payload.data(using: .utf8) {
            do {
                return try JSONDecoder().decode(API.wsV1.WSMsgStatusUpdateNotification.self, from: data).payload
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


