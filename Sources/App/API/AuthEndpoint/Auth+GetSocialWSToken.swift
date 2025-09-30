//
//  Auth+GetSocialWSToken.swift
//  
//
//  Created by Victor Cantu on 10/16/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension AuthEndpointV1 {
    
    static func getSocialWSToken(callback: @escaping ( (_ resp: APIResponseGeneric<GetChatTokenResponse>?) -> () )) {
        
        sendPost(
            rout,
            version,
            "getSocialWSToken",
            EmptyPayload()
        ) { resp in
            
                guard let data = resp else{
                    callback(nil)
                    return
                }
            
                do{
                    let resp = try JSONDecoder().decode(
                        APIResponseGeneric<GetChatTokenResponse>.self, from: data)
                    
                    callback(resp)
                    
                }
                catch{
                    
                    print(error)
                    
                    callback(nil)
                }
            }
    }
}
