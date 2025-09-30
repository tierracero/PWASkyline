//
//  WS+AsyncFileUpdate.swift
//  
//
//  Created by Victor Cantu on 2/4/25.
//

import Foundation
import Foundation
import TCFundamentals
import TCFireSignal

extension WS {
    func asyncFileUpdate(_ payload: String) -> API.wsV1.AsyncFileUpdate? {
        
        if let data = payload.data(using: .utf8) {
            do {
                return try JSONDecoder().decode(API.wsV1.AsyncFileUpdateNotification.self, from: data).payload
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

