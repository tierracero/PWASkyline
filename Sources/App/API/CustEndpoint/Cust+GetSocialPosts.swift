//
//  Cust+GetSocialPosts.swift
//  
//
//  Created by Victor Cantu on 4/10/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustComponents {
        
    static func getSocialPosts(
        getFrom: GetFromDate,
        profile: SocialProfileType?,
        callback: @escaping ( (_ resp: APIResponseGeneric<GetSocialPostsResponse>?) -> () )
    ) {
        
        loadingView(show: true)
        
        sendPost(
            rout,
            version,
            "getSocialPosts",
            GetSocialPostsRequest(
                getFrom: getFrom,
                profile: profile
            )
        ) { payload in
            
            loadingView(show: false)
            
            guard let data = payload else{
                callback( nil )
                return
            }
            
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<GetSocialPostsResponse>.self, from: data)
                
                callback(resp)
                
            }
            catch{
                callback( nil )
            }
        }
    }
}
