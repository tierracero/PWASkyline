//
//  WS+CustFetchUsers.swift
//  
//
//  Created by Victor Cantu on 8/8/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension WSEndpointV1 {
    
    
    /// Returns list of private and public chats
    /// - Parameter callback: CustFetchUsersResponse
    public static func custFetchUsers(callback: @escaping ( (_ resp: APIResponseGeneric<CustFetchUsersResponse>?) -> () )) {
        
        sendPost(
            rout,
            version,
            "custFetchUsers",
            EmptyPayload()
        ) { payload in
            guard let data = payload else{
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<CustFetchUsersResponse>.self, from: data)
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
