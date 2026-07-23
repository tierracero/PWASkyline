//
//  WS+RequestMobileCamara+Progress.swift
//  
//
//  Created by Victor Cantu on 5/3/23.
//
import Foundation
import TCFundamentals
import TCFireSignal

extension WS {
    
    func requestMobileCamaraProgress(_ payload: String) -> API.webSocketV1.RequestMobileCamaraProgressResponse? {
        
        if let data = payload.data(using: .utf8) {
            do {
                return try JSONDecoder().decode(API.webSocketV1.WebSocketPayload<API.webSocketV1.RequestMobileCamaraProgressResponse>.self, from: data).payload
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
