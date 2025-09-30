//
//  Theme+SaveWebMeetUs.swift
//  
//
//  Created by Victor Cantu on 1/20/25.
//

import Foundation
import TCFundamentals
import TCFireSignal
import TaecelAPICore

extension ThemeEndpointV1 {
    
    public static func saveWebMeetUs(
        configLanguage: LanguageCode,
        metaTitle: String,
        metaDescription: String,
        title: String,
        bisName: String,
        slogan: String,
        mantra: String,
        description: String,
        mainText: String,
        subText: String,
        history: String,
        vision: String,
        callback: @escaping ( (_ resp: APIResponse?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "saveWebMeetUs",
            SaveWebMeetUsRequest(
                configLanguage: configLanguage,
                metaTitle: metaTitle,
                metaDescription: metaDescription,
                title: title,
                bisName: bisName,
                slogan: slogan,
                mantra: mantra,
                description: description,
                mainText: mainText,
                subText: subText,
                history: history,
                vision: vision
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
