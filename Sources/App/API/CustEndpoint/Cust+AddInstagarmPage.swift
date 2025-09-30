//
//  Cust+AddInstagarmPage.swift
//  
//
//  Created by Victor Cantu on 10/19/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustAPIEndpointV1 {
    
    static func addInstagramPage(
        userid: String,
        name: String,
        pageid: String,
        token: String,
        username: String,
        avatar: String,
        callback: @escaping ( (_ resp: APIResponseGeneric<CustSocialPageQuick>?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "addInstagramPage",
            AddFacebookPageRequest(
                userid: userid,
                name: name,
                pageid: pageid,
                token: token,
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
