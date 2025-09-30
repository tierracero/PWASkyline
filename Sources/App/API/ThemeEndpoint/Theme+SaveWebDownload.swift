//
//  Theme+SaveWebDownload.swift
//
//
//  Created by Victor Cantu on 1/20/25.
//

import Foundation
import TCFundamentals
import TCFireSignal
import TaecelAPICore

extension ThemeEndpointV1 {
    
    public static func saveWebDownload(
        configLanguage: LanguageCode,
        metaTitle: String,
        metaDescription: String,
        title: String,
        description: String,
        mainText: String,
        subText: String,
        callback: @escaping ( (_ resp: APIResponse?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "saveWebDownload",
            SaveWebDownloadRequest(
                configLanguage: configLanguage,
                metaTitle: metaTitle,
                metaDescription: metaDescription,
                title: title,
                description: description,
                mainText: mainText,
                subText: subText
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
