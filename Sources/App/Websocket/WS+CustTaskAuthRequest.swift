//
//  WS+CustTaskAuthRequest.swift
//  
//
//  Created by Victor Cantu on 5/8/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension WS {
    
    func custTaskAuthRequest(_ payload: String) -> CustTaskAuthorizationManagerQuick? {
        
        if let data = payload.data(using: .utf8) {
            do {
                return try JSONDecoder().decode(API.wsV1.CustTaskAuthRequest.self, from: data).payload
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
