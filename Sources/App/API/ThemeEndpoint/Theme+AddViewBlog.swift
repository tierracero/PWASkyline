//
//  Theme+AddViewBlog.swift
//
//
//  Created by Victor Cantu on 1/16/25.
//

import Foundation
import TCFundamentals
import TCFireSignal
import TaecelAPICore

extension ThemeEndpointV1 {
    
    public static func addViewBlog(
        name: String,
        smallDescription: String,
        description: String,
        link: String?,
        configLanguage: LanguageCode,
        inPromo: Bool,
        files: [FileObject],
        callback: @escaping ( (_ resp: APIResponseGeneric<AddViewBlogResponse>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "addViewBlog",
            AddViewBlogRequest(
                name: name,
                smallDescription: smallDescription,
                description: description,
                link: link,
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
                callback(try JSONDecoder().decode(APIResponseGeneric<AddViewBlogResponse>.self, from: data))
            }
            catch{
                print("⭕️ \(#file)")
                print(error)
                callback(nil)
            }
            
        }
    }
}
