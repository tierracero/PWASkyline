//
//  WS+NotifyAddFacebookProfile.swift
//  
//
//  Created by Victor Cantu on 10/18/22.
//

import Foundation
import TCFundamentals

extension WS {
    func notifyAddFacebookProfile(_ payload: String) -> CustSocialProfileQuick? {
        
        print("⭐️  notifyAddFacebookProfile  ⭐️")
        print(payload)
        
        if let data = payload.data(using: .utf8) {
            do {
                return try JSONDecoder().decode(API.wsV1.AddFacebookProfileNotification.self, from: data).payload
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
