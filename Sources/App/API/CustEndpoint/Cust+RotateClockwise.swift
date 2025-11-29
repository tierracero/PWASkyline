//
//  Cust+RotateClockwise.swift
//  
//
//  Created by Victor Cantu on 4/11/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustComponents {
        
    static func rotateClockwise(
        relid: UUID,
        fileName: String,
        type: MediaDownloadType,
        callback: @escaping ( (_ resp: APIResponseGeneric<RotateClockwiseResponse>?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "rotateClockwise",
            RotateClockwiseRequest(
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
                let resp = try JSONDecoder().decode(APIResponseGeneric<RotateClockwiseResponse>.self, from: data)
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
