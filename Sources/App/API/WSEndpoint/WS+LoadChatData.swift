//
//  WS+LoadChatData.swift
//  
//
//  Created by Victor Cantu on 8/8/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

/// userToUser, public, userToSiwe, siweToSiwe, customerService, social
/// siwe, facebook, instagram, youtube, tiktok, pintrest, twitter, snapchat, googleplus, general
extension WSEndpointV1 {
    
    public static func loadChatData(
        type: RoomType,
        profileType: SocialProfileType?,
        roomid: HybridIdentifier,
        callback: @escaping ( (_ resp: APIResponseGeneric<LoadChatDataResponse>?) -> () )) {
        
        sendPost(
            rout,
            version,
            "loadChatData",
            LoadChatDataRequest(
                type: type,
                profileType: profileType,
                roomid: roomid
            )
        ) { payload in
            guard let data = payload else{
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<LoadChatDataResponse>.self, from: data)
                callback(resp)
            }
            catch{
                print("⭕️ loadActiveTCAccounts")
                print(error)
                callback(nil)
            }
        }
    }
}
