//
//  Theme+GetWebAlbum.swift
//  
//
//  Created by Victor Cantu on 1/16/25.
//

import Foundation
import TCFundamentals
import TCFireSignal
import TaecelAPICore

extension ThemeComponents {
    
    public static func getWebAlbum(
        theme: String,
        configLanguage: LanguageCode,
        callback: @escaping ( (_ resp: APIResponseGeneric<GetWebAlbumResponse>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "getWebAlbum",
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
                callback(try JSONDecoder().decode(APIResponseGeneric<GetWebAlbumResponse>.self, from: data))
            }
            catch{
                print("⭕️ \(#file)")
                print(error)
                callback(nil)
            }
            
        }
    }
}
