//
//  Theme+SaveViewBlog.swift
//  
//
//  Created by Victor Cantu on 1/19/25.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension ThemeComponents {
    
    public static func saveViewBlog(
        id: UUID,
        name: String,
        smallDescription: String,
        description: String,
        link: String?,
        configLanguage: LanguageCode,
        inPromo: Bool,
        callback: @escaping ( (_ resp: APIResponse?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "saveViewBlog",
            SaveViewBlogRequest(
                id: id,
                name: name,
                smallDescription: smallDescription,
                description: description,
                link: link,
                configLanguage: configLanguage,
                inPromo: inPromo
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
