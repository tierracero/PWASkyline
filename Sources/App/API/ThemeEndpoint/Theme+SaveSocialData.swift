//
//  Theme+SaveSocialData.swift
//
//
//  Created by Victor Cantu on 1/19/25.
//

import Foundation
import TCFundamentals
import TCFireSignal
import TaecelAPICore

extension ThemeEndpointV1 {
    
    public static func saveSocialData(
        lang: LanguageCode,
        facebookLink: String?,
        instagramLink: String?,
        twitterLink: String?,
        youtubeLink: String?,
        pinterestLink: String?,
        tiktokLink: String?,
        callback: @escaping ( (_ resp: APIResponse?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "saveSocialData",
            SaveSocialDataRequest(
                lang: lang,
                facebookLink: facebookLink,
                instagramLink: instagramLink,
                twitterLink: twitterLink,
                youtubeLink: youtubeLink,
                pinterestLink: pinterestLink,
                tiktokLink: tiktokLink
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
