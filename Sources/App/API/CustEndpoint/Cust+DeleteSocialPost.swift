//
//  Cust+DeleteSocialPost.swift
//  
//
//  Created by Victor Cantu on 4/15/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustAPIEndpointV1 {
        
    static func deleteSocialPost(
        profileType: SocialProfileType,
        pageid: String,
        postid: String,
        callback: @escaping ( (_ resp: APIResponse?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "deleteSocialPost",
            DeleteSocialPostRequest(
                profileType: profileType,
                pageid: pageid,
                postid: postid
            )
        ) { payload in
            
            guard let data = payload else{
                callback(nil)
                return
            }
            
            do{
                let resp = try JSONDecoder().decode(APIResponse?.self, from: data)
                callback(resp)
            }
            catch {
                callback(nil)
            }
            
        }
    }
}
