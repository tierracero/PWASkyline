//
//  Auth+GetChatToken.swift
//  
//
//  Created by Victor Cantu on 8/7/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension AuthComponents {
    
    static func getChatToken(callback: @escaping ( (_ resp: APIResponseGeneric<GetChatTokenResponse>?) -> () )) {
        
        sendPost(
            rout,
            version,
            "getChatToken",
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

