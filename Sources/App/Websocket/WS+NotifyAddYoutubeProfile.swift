//
//  WS+NotifyAddYoutubeProfile.swift
//  
//
//  Created by Victor Cantu on 1/2/23.
//

import Foundation
import TCFundamentals

extension WS {
    
    func notifyAddYoutubeProfile(_ payload: String) -> CustSocialProfileQuick? {
        
        print("⭐️  notifyAddYoutubeProfile  ⭐️")
        print(payload)
        
        if let data = payload.data(using: .utf8) {
            do {
                return try JSONDecoder().decode(API.wsV1.AddYoutubeProfileNotification.self, from: data).payload
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
