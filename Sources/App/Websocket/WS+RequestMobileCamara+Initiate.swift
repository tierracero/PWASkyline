//
//  WS+RequestMobileCamara+Initiate.swift
//  
//
//  Created by Victor Cantu on 5/3/23.
//
import Foundation
import TCFundamentals
import TCFireSignal

extension WS {
    func requestMobileCamaraInitiate(_ payload: String) -> API.wsV1.RequestMobileCamaraInitiateResponse? {
        
        if let data = payload.data(using: .utf8) {
            do {
                return try JSONDecoder().decode(API.wsV1.WebSocketPayload<API.wsV1.RequestMobileCamaraInitiateResponse>.self, from: data).payload
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
