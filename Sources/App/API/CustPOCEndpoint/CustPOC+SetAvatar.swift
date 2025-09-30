//
//  CustPOC+SetAvatar.swift
//  
//
//  Created by Victor Cantu on 2/4/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustPOCEndpointV1 {
    
    static func setAvatar(
        poc: UUID,
        id: UUID,
        img: String,
        callback: @escaping ( (_ resp: APIResponse?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "setAvatar",
            SetAvatarRequest(
                poc: poc,
                id: id,
                img: img
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
                print(error)
                callback(nil)
            }
        }
    }
}
