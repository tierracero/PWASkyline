//
//  Cust+GetYoutubeChannels.swift
//  
//
//  Created by Victor Cantu on 1/3/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustAPIEndpointV1 {
        
    static func getYoutubeChannels(
        callback: @escaping ( (_ resp: APIResponseGeneric<API.custAPIV1.GetYoutubeChannelsResponse>?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "getYoutubeChannels",
            EmptyPayload()
        ) { payload in
            
            guard let data = payload else{
                callback(nil)
                return
            }
            
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<API.custAPIV1.GetYoutubeChannelsResponse>.self, from: data)
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

