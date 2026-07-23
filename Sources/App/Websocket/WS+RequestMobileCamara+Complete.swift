//
//  WS+RequestMobileCamara+Complete.swift
//  
//
//  Created by Victor Cantu on 5/3/23.
//
import Foundation
import TCFundamentals
import TCFireSignal

extension WS {
    func requestMobileCamaraComplete(_ payload: String) -> API.webSocketV1.RequestMobileCamaraCompleteResponse? {
        
        if let data = payload.data(using: .utf8) {
            do {
                return try JSONDecoder().decode(API.webSocketV1.WebSocketPayload<API.webSocketV1.RequestMobileCamaraCompleteResponse>.self, from: data).payload
            } catch {
                print("🔴  requestMobileCamaraComplete")
                print(error)
                return nil
            }
        }
        else{
            return nil
        }
    }
}
