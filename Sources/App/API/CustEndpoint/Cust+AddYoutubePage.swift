//
//  Cust+AddYoutubePage.swift
//  
//
//  Created by Victor Cantu on 1/3/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustComponents {
    
    static func addYoutubePage(
        name: String,
        pageid: String,
        username: String,
        avatar: String,
        callback: @escaping ( (_ resp: APIResponseGeneric<CustSocialPageQuick>?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "addYoutubePage",
            AddYoutubePageRequest(
                name: name,
                pageid: pageid,
                username: username,
                avatar: avatar
            )
        ) { payload in
            
            guard let data = payload else{
                callback(nil)
                return
            }
            
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<CustSocialPageQuick>.self, from: data)
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
