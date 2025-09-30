//
//  WS+CustTaskAuthoroized.swift
//  
//
//  Created by Victor Cantu on 5/9/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension WS {
    
    func custTaskAuthoroized(_ payload: String) -> CustTaskAuthorizationManagerQuick? {
        
        if let data = payload.data(using: .utf8) {
            do {
                return try JSONDecoder().decode(API.wsV1.WebSocketPayload<CustTaskAuthorizationManagerQuick>.self, from: data).payload
            }
            catch {
                print(error)
                return nil
            }
        }
        else{
            return nil
        }
    }
    
}
