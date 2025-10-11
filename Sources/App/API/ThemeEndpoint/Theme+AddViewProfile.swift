//
//  Theme+AddViewProfile.swift
//
//
//  Created by Victor Cantu on 1/16/25.
//

import Foundation
import TCFundamentals
import TCFireSignal
import TaecelAPICore

extension ThemeEndpointV1 {
    
    public static func addViewProfile(
        name: String,
        smallDescription: String,
        description: String,
        configLanguage: LanguageCode,
        inPromo: Bool,
        files: [FileObject],
        callback: @escaping ( (_ resp: APIResponseGeneric<AddViewProfileResponse>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "addViewProfile",
            AddViewProfileRequest(
                name: name,
                smallDescription: smallDescription,
                description: description,
                configLanguage: configLanguage,
                inPromo: inPromo,
                files: files
            )
        ) { data in
            
            guard let data else{
                callback(nil)
                return
            }
            
            do{
                callback(try JSONDecoder().decode(APIResponseGeneric<AddViewProfileResponse>.self, from: data))
            }
            catch{
                print("⭕️ \(#file)")
                print(error)
                callback(nil)
            }
            
        }
    }
}
