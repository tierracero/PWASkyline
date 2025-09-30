//
//  Cust+RotateCounterClockwise.swift
//  
//
//  Created by Victor Cantu on 4/11/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustAPIEndpointV1 {
        
    static func rotateCounterClockwise(
        relid: UUID,
        fileName: String,
        type: MediaDownloadType,
        callback: @escaping ( (_ resp: APIResponseGeneric<RotateCounterClockwiseResponse>?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "rotateCounterClockwise",
            RotateCounterClockwiseRequest(
                relid: relid,
                fileName: fileName,
                type: type
            )
        ) { payload in
            
            guard let data = payload else {
                callback(nil)
                return
            }
            
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<RotateCounterClockwiseResponse>.self, from: data)
                callback(resp)
            }
            catch{
                print("🔴 API_DECODING_ERROR")
                print(error)
                callback(nil)
            }
        }
    }
}

