//
//  Theme+GetViewProfiles.swift
//
//
//  Created by Victor Cantu on 1/16/25.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension ThemeEndpointV1 {
    
    public static func getViewProfiles(
        configLanguage: LanguageCode,
        callback: @escaping ( (_ resp: APIResponseGeneric<GetViewProfilesResponse>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "getViewProfiles",
            GetViewProfilesRequest(
                configLanguage: configLanguage
            )
        ) { data in
            
            guard let data else{
                callback(nil)
                return
            }
            
            do{
                callback(try JSONDecoder().decode(APIResponseGeneric<GetViewProfilesResponse>.self, from: data))
            }
            catch{
                print("⭕️ \(#file)")
                print(error)
                callback(nil)
            }
            
        }
    }
}
