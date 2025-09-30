//
//  WS+NotifyLogout.swift
//  
//
//  Created by Victor Cantu on 8/10/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension WS {
    func notifyLogout(_ payload: String) -> API.wsV1.NotifyLogout? {
        
        print("⭐️  notifyLogout  ⭐️")
        print(payload)
        
        if let data = payload.data(using: .utf8) {
            do {
                return try JSONDecoder().decode(API.wsV1.NotifyLogoutNotification.self, from: data).payload
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
