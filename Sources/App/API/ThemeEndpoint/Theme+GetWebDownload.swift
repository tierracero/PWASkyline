//
//  Theme+GetWebDownload.swift
//
//
//  Created by Victor Cantu on 1/16/25.
//

import Foundation
import TCFundamentals
import TCFireSignal
import TaecelAPICore

extension ThemeEndpointV1 {
    
    public static func getWebDownload(
        theme: String,
        configLanguage: LanguageCode,
        callback: @escaping ( (_ resp: APIResponseGeneric<GetWebDownloadResponse>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "getWebDownload",
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
                callback(try JSONDecoder().decode(APIResponseGeneric<GetWebDownloadResponse>.self, from: data))
            }
            catch{
                print("⭕️ \(#file)")
                print(error)
                callback(nil)
            }
            
        }
    }
}
