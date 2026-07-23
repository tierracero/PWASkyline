//
//  WS+RequestMobileOCRComplete.swift
//  
//
//  Created by Victor Cantu on 5/5/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension WS {
    func requestMobileOCRComplete(_ payload: String) -> API.webSocketV1.RequestMobileOCRCompleteResponse? {
        
        if let data = payload.data(using: .utf8) {
            do {
                return try JSONDecoder().decode(API.webSocketV1.WebSocketPayload<API.webSocketV1.RequestMobileOCRCompleteResponse>.self, from: data).payload
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
