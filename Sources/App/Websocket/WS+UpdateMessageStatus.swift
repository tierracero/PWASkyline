//
//  WS+UpdateMessageStatus.swift
//  
//
//  Created by Victor Cantu on 8/12/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension WS {
    func updateMessageStatus(_ payload: String) -> API.wsV1.UpdateMessageStatus? {
        
        if let data = payload.data(using: .utf8) {
            do {
                return try JSONDecoder().decode(API.wsV1.UpdateMessageStatusNotification.self, from: data).payload
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
