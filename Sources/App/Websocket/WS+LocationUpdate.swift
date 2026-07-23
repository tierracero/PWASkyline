//
//  WS+LocationUpdate.swift
//
//
//  Created by Victor Cantu on 5/15/24.
//

import Foundation


import Foundation
import TCFundamentals
import TCFireSignal

extension WS {
    func locationUpdate(_ payload: String) -> API.webSocketV1.WSLocationUpdate? {
        
        if let data = payload.data(using: .utf8) {
            do {
                return try JSONDecoder().decode(API.webSocketV1.WSLocationUpdateNotification.self, from: data).payload
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
