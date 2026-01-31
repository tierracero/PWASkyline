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
    func asyncFileOCR(_ payload: String) -> API.wsV1.AsyncFileOCR? {
        
        if let data = payload.data(using: .utf8) {
            do {
                return try JSONDecoder().decode(API.wsV1.AsyncFileOCRNotification.self, from: data).payload
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