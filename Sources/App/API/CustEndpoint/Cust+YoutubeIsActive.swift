//
//  Cust+YoutubeIsActive.swift
//  
//
//  Created by Victor Cantu on 1/3/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustAPIEndpointV1 {
        
    static func youtubeIsActive(
        callback: @escaping ( (_ resp: APIResponse?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "youtubeIsActive",
            EmptyPayload()
        ) { payload in
            
            guard let data = payload else {
                callback(nil)
                return
            }
            
            do{
                let resp = try JSONDecoder().decode(APIResponse.self, from: data)
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
