//
//  Auth+CustomerLogout.swift
//  
//
//  Created by Victor Cantu on 3/30/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension AuthComponents {
    
    static func customerLogout(callback: @escaping ( (_ resp: APIResponse?) -> () )) {
        
        sendPost(
            rout,
            version,
            "customerLogout",
            EmptyPayload()
        ) { data in
            
                guard let data else{
                    callback(nil)
                    return
                }
            
                do{
                    callback(try JSONDecoder().decode(APIResponse.self, from: data)) 
                }
                catch{
                    
                    print(error)
                    
                    callback(nil)
                }
            
            }
    }
}

