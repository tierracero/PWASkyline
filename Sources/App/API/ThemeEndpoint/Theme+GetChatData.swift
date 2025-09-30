//
//  Theme+GetChatData.swift
//  
//
//  Created by Victor Cantu on 1/20/25.
//

import Foundation
import TCFundamentals
import TCFireSignal
import TaecelAPICore

extension ThemeEndpointV1 {
    
    public static func getChatData(
        lang: LanguageCode,
        callback: @escaping ( (_ resp: APIResponseGeneric<CustChatConfiguration>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "getChatData",
            GetChatDataRequest(
                lang: lang
            )
        ) { data in
            
            guard let data else{
                callback(nil)
                return
            }
            
            do{
                callback(try JSONDecoder().decode(APIResponseGeneric<CustChatConfiguration>.self, from: data))
            }
            catch{
                print("⭕️ \(#file)")
                print(error)
                callback(nil)
            }
            
        }
    }
}
