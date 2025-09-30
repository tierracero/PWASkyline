//
//  WS+GetChatRoom.swift
//  
//
//  Created by Victor Cantu on 8/23/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension WSEndpointV1 {
    
    public static func getChatRoom(
        roomid: HybridIdentifier,
        callback: @escaping ( (_ resp: APIResponseGeneric<CustChatRoomProfile>?) -> () )) {
            
        sendPost(
            rout,
            version,
            "getChatRoom",
            
            API.wsV1.GetChatRoomRequest(
                roomid: roomid
            )
        ) { payload in
            
            guard let payload = payload else {
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<CustChatRoomProfile>.self, from: payload)
                callback(resp)
            }
            catch{
                print("⭕️ getChatRoom")
                print(error)
                callback(nil)
            }
        }
    }
}
