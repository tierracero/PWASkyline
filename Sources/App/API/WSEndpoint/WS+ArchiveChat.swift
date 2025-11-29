//
//  WS+ArchiveChat.swift
//  
//
//  Created by Victor Cantu on 8/24/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension WSComponents {
    
    public static func archiveChat(
        roomid: HybridIdentifier,
        pageid: String,
        callback: @escaping ( (_ resp: APIResponse?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "archiveChat",
            ArchiveChatRequest(
                roomid: roomid,
                pageid: pageid
            )
        ) { payload in
            
            guard let payload else{
                callback(nil)
                return
            }
            
            do{
                let resp = try JSONDecoder().decode(APIResponse.self, from: payload)
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

