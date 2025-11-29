//
//  Cust+GetSocialPostManager.swift
//  
//
//  Created by Victor Cantu on 4/13/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustComponents {
        
    static func getSocialPostManager(
        managerid: UUID,
        profileType: SocialProfileType,
        postType: SocialPostType,
        pageid: String,
        postid: String,
        mediaid: String,
        callback: @escaping ( (_ resp: APIResponseGeneric<GetSocialPostManagerResponse>?) -> () )
    ) {
        
        loadingView(show: true)
        
        sendPost(
            rout,
            version,
            "getSocialPostManager",
            GetSocialPostManagerRequest(
                managerid: managerid,
                profileType: profileType,
                postType: postType,
                pageid: pageid,
                postid: postid,
                mediaid: mediaid
            )
        ) { payload in
            
            loadingView(show: false)
            
            guard let data = payload else{
                callback( nil )
                return
            }
            
            do{
                
                let resp = try JSONDecoder().decode(APIResponseGeneric<GetSocialPostManagerResponse>.self, from: data)
                
                callback(resp)
                
            }
            catch{
                callback( nil )
            }
        }
    }
}
