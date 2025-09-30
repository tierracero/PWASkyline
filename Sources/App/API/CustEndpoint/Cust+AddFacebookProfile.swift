//
//  Cust+AddFacebookProfile.swift
//  
//
//  Created by Victor Cantu on 10/18/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustAPIEndpointV1 {
    
    static func addFacebookProfile(
        connid: String,
        accessToken: String,
        expiresIn: Int64,
        dataAccessExpirationTime: Int64,
        signedRequest: String,
        userID: String,
        callback: @escaping ( (_ resp: APIResponse?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "addFacebookProfile",
            AddFacebookProfileRequest(
                connid: connid,
                accessToken: accessToken,
                expiresIn: expiresIn,
                dataAccessExpirationTime: dataAccessExpirationTime,
                signedRequest: signedRequest,
                userID: userID
            )
        ) { payload in
            
            guard let data = payload else{
                callback(nil)
                return
            }
            
            do{
                let resp = try JSONDecoder().decode(APIResponse.self, from: data)
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

