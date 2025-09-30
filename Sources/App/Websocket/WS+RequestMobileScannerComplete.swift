//
//  WS+RequestMobileScannerComplete.swift
//  
//
//  Created by Victor Cantu on 5/5/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension WS {
    func requestMobileScannerComplete(_ payload: String) -> API.wsV1.RequestMobileScannerCompleteResponse? {
        
        if let data = payload.data(using: .utf8) {
            do {
                return try JSONDecoder().decode(API.wsV1.WebSocketPayload<API.wsV1.RequestMobileScannerCompleteResponse>.self, from: data).payload
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
