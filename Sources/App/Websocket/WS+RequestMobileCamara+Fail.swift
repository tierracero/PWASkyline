//
//  WS+RequestMobileCamara+Fail.swift
//  
//
//  Created by Victor Cantu on 5/3/23.
//
import Foundation
import TCFundamentals
import TCFireSignal

extension WS {
    func requestMobileCamaraFail(_ payload: String) -> API.wsV1.RequestMobileCamaraFailResponse? {
        
        if let data = payload.data(using: .utf8) {
            do {
                return try JSONDecoder().decode(API.wsV1.WebSocketPayload<API.wsV1.RequestMobileCamaraFailResponse>.self, from: data).payload
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
