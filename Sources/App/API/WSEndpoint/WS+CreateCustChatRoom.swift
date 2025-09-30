//
//  WS+CreateCustChatRoom.swift
//  
//
//  Created by Victor Cantu on 8/9/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension WSEndpointV1 {
    
    public static func createCustChatRoom(
        id: UUID,
        callback: @escaping ( (_ resp: APIResponseGeneric<CreateCustChatRoomResponse>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "createCustChatRoom",
            APIRequestID(id: id, store: nil)
        ) { payload in
            guard let data = payload else{
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<CreateCustChatRoomResponse>.self, from: data)
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

