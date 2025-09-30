//
//  Theme+UpdateActiveButtons.swift
//
//
//  Created by Victor Cantu on 1/20/25.
//

import Foundation
import TCFundamentals
import TCFireSignal
import TaecelAPICore

extension ThemeEndpointV1 {
    
    public static func updateActiveButtons(
        buttons: [WebPageLink],
        callback: @escaping ( (_ resp: APIResponse?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "updateActiveButtons",
            UpdateActiveButtonsRequest(
               buttons: buttons
           )
        ) { data in
            
            guard let data else{
                callback(nil)
                return
            }
            
            do{
                callback(try JSONDecoder().decode(APIResponse.self, from: data))
            }
            catch{
                print("⭕️ \(#file)")
                print(error)
                callback(nil)
            }
            
        }
    }
}
