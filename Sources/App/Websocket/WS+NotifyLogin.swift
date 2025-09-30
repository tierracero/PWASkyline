//
//  WS+NotifyLogin.swift
//  
//
//  Created by Victor Cantu on 8/10/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension WS {
    func notifyLogin(_ payload: String) -> API.wsV1.NotifyLogin? {
        
        print("⭐️  notifyLogin  ⭐️")
        print(payload)
        
        if let data = payload.data(using: .utf8) {
            do {
                return try JSONDecoder().decode(API.wsV1.NotifyLoginNotification.self, from: data).payload
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
