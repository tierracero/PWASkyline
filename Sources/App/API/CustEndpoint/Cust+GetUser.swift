//
//  Cust+GetUser.swift
//
//
//  Created by Victor Cantu on 6/26/24.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustAPIEndpointV1 {
        
    static func getUser(
        id: GetUserBy,
        full: Bool,
        callback: @escaping ((_ resp: APIResponseGeneric<GetUserResponse>?) -> ())
    ) {
        sendPost(
            rout,
            version,
            "getUser",
            GetUserRequest(
                id: id,
                full: full
            )
        ) { payload in
            
            guard let data = payload else{
                callback(nil)
                return
            }
            
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<GetUserResponse>.self, from: data)
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

