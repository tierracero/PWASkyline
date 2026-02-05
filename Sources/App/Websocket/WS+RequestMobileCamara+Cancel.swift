//
//  WS+RequestMobileCamara+Cancel.swift
//  
//
//  Created by Victor Cantu on 5/5/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension WS {
    
    func requestMobileCamaraCancel(_ payload: String) -> API.wsV1.RequestMobileCamaraCancelResponse? {
        
        if let data = payload.data(using: .utf8) {
            do {
                return try JSONDecoder().decode(API.wsV1.WebSocketPayload<API.wsV1.RequestMobileCamaraCancelResponse>.self, from: data).payload
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
