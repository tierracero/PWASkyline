//
//  PapaContador+ChangeSATPassword.swift
//  
//
//  Created by Victor Cantu on 6/13/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

/*
extension PapaContadorEndpointV1 {
    
    public static func changeSATPassword(
        id: UUID,
        password: String,
        callback: @escaping ( (_ resp: APIResponse?) -> () )) {
        
            //API.papaContadorV1.ChangeSATPasswordRequest
            
        sendPost(
            rout,
            version,
            "changeSATPassword",
            ChangeSATPasswordRequest(
                id: id,
                password: password
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
                print("⭕️ changeSATPassword")
                print(error)
                callback(nil)
            }
        }
    }
}
*/