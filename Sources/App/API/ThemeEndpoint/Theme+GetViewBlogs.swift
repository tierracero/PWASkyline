//
//  Theme+GetViewBlogs.swift
//
//
//  Created by Victor Cantu on 1/16/25.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension ThemeEndpointV1 {
    
    public static func getViewBlogs(
        configLanguage: LanguageCode,
        callback: @escaping ( (_ resp: APIResponseGeneric<GetViewBlogsResponse>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "getViewBlogs",
            GetViewBlogsRequest(
                configLanguage: configLanguage
            )
        ) { data in
            
            guard let data else {
                callback(nil)
                return
            }
            
            do{
                callback(try JSONDecoder().decode(APIResponseGeneric<GetViewBlogsResponse>.self, from: data))
            }
            catch{
                print("⭕️ \(#file)")
                print(error)
                callback(nil)
            }
            
        }
    }
}
