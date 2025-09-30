//
//  Theme+GetWebContact.swift
//
//
//  Created by Victor Cantu on 1/16/25.
//

import Foundation
import TCFundamentals
import TCFireSignal
import TaecelAPICore

extension ThemeEndpointV1 {
    
    public static func getWebContact(
        theme: String,
        configLanguage: LanguageCode,
        callback: @escaping ( (_ resp: APIResponseGeneric<GetWebContactResponse>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "getWebContact",
            GetWebDataRequest(
                theme: theme,
                configLanguage: configLanguage
            )
        ) { data in
            
            guard let data else{
                callback(nil)
                return
            }
            
            do{
                callback(try JSONDecoder().decode(APIResponseGeneric<GetWebContactResponse>.self, from: data))
            }
            catch{
                print("⭕️ \(#file)")
                print(error)
                callback(nil)
            }
            
        }
    }
}
