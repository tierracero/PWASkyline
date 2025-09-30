//
//  Cust+DeleteSocialComment.swift
//  
//
//  Created by Victor Cantu on 4/15/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustAPIEndpointV1 {
        
    static func deleteSocialComment(
        profileType: SocialProfileType,
        pageid: String,
        commentid: String,
        callback: @escaping ( (_ resp: APIResponse?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "deleteSocialComment",
            DeleteSocialCommentRequest(
                profileType: profileType,
                pageid: pageid,
                commentid: commentid
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
