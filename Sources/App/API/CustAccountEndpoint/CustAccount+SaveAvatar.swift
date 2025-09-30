//
//  CustAccount+SaveAvatar.swift
//  
//
//  Created by Victor Cantu on 1/22/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustAccountEndpointV1 {
    
    public static func saveAvatar(
        accountid: UUID,
        base64: String?,
        callback: @escaping ( (_ resp: APIResponseGeneric<String>?) -> () )) {
        
        sendPost(
            rout,
            version,
            "saveAvatar",
            SaveAvatarRequest(
                accountid: accountid,
                base64: base64
            )
        ) { payload in
            guard let data = payload else{
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<String>.self, from: data)
                callback(resp)
            }
            catch{
                print("⭕️ loadDetails \(#function)")
                print(error)
                callback(nil)
            }
        }
    }
}

