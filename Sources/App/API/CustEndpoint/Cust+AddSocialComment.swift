//
//  Cust+AddSocialComment.swift
//  
//
//  Created by Victor Cantu on 4/15/23.
//

import Foundation
import TCFundamentals
import TCSocialCore
import TCFireSignal

extension CustComponents {
    
    static func addSocialComment(
        mainid: UUID,
        managerid: UUID,
        profileType: SocialProfileType,
        pageid: String,
        postid: String,
        commentid: String?,
        message: String,
        callback: @escaping ( (_ resp: APIResponseGeneric<Comment>?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "addSocialComment",
            AddSocialCommentRequest(
                mainid: mainid,
                managerid: managerid,
                profileType: profileType,
                pageid: pageid,
                postid: postid,
                commentid: commentid,
                message: message
            )
        ) { payload in
            
            guard let data = payload else{
                callback(nil)
                return
            }
            
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<Comment>.self, from: data)
                callback(resp)
            }
            catch{
                print("🔴 API_DECODING_ERROR")
                print(error)
                callback(nil)
            }
        }
    }
}
