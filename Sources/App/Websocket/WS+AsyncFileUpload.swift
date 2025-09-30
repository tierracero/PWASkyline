//
//  WS+AsyncFileUpload.swift
//
//
//  Created by Victor Cantu on 10/7/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension WS {
    func asyncFileUpload(_ payload: String) -> CustAPIEndpointV1.UploadManagerFileObject? {
        
        if let data = payload.data(using: .utf8) {
            do {
                return try JSONDecoder().decode(API.wsV1.AsyncFileUpload.self, from: data).payload
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

