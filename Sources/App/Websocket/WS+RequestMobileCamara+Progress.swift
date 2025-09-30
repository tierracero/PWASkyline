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
    
    func requestMobileCamaraProgress(_ payload: String) -> API.wsV1.RequestMobileCamaraProgressResponse? {
        
        if let data = payload.data(using: .utf8) {
            do {
                return try JSONDecoder().decode(API.wsV1.WebSocketPayload<API.wsV1.RequestMobileCamaraProgressResponse>.self, from: data).payload
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
