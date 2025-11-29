//
//  WS+AsyncCropImage.swift
//
//
//  Created by Victor Cantu on 10/8/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension WS {
    func asyncCropImage(_ payload: String) -> CustComponents.UploadManagerFileObject? {
        
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
