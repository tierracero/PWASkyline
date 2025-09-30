//
//  Theme+SaveWebAvatar.swift
//
//
//  Created by Victor Cantu on 1/22/25.
//

import Foundation
import TCFundamentals
import TCFireSignal
import TaecelAPICore

extension ThemeEndpointV1 {
    
    public static func saveWebAvatar(
        objectType: CustWebFilesObjectType,
        configLanguage: LanguageCode,
        fileName: String,
        callback: @escaping ( (_ resp: APIResponse?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "saveWebAvatar",
            SaveWebAvatarRequest(
                objectType: objectType,
                configLanguage: configLanguage,
                fileName: fileName
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
