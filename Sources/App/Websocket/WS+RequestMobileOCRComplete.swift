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
    func requestMobileOCRComplete(_ payload: String) -> API.wsV1.RequestMobileOCRCompleteResponse? {
        
        if let data = payload.data(using: .utf8) {
            do {
                return try JSONDecoder().decode(API.wsV1.WebSocketPayload<API.wsV1.RequestMobileOCRCompleteResponse>.self, from: data).payload
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
