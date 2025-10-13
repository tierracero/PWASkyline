//
//  Theme+GetViewBlog.swift
//  
//
//  Created by Victor Cantu on 1/16/25.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension ThemeEndpointV1 {
    
    public static func getViewBlog(
        id: UUID,
        callback: @escaping ( (_ resp: APIResponseGeneric<GetViewBlogResponse>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "getViewBlog",
            GetViewBlogRequest(
                id: id
            )
        ) { data in
            
            guard let data else{
                callback(nil)
                return
            }
            
            do{
                callback(try JSONDecoder().decode(APIResponseGeneric<GetViewBlogResponse>.self, from: data))
            }
            catch{
                print("⭕️ \(#file)")
                print(error)
                callback(nil)
            }
            
        }
    }
}
