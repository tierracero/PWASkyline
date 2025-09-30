//
//  Theme+GetWebButtons.swift
//
//
//  Created by Victor Cantu on 1/19/25.
//

import Foundation
import TCFundamentals
import TCFireSignal
import TaecelAPICore

extension ThemeEndpointV1 {
    
    public static func getWebButtons(
        callback: @escaping ( (_ resp: APIResponseGeneric<GetWebButtonsResponse>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "getWebButtons",
            EmptyPayload()
        ) { data in
            
            guard let data else{
                callback(nil)
                return
            }
            
            do{
                callback(try JSONDecoder().decode(APIResponseGeneric<GetWebButtonsResponse>.self, from: data))
            }
            catch{
                print("⭕️ \(#file)")
                print(error)
                callback(nil)
            }
            
        }
    }
}
