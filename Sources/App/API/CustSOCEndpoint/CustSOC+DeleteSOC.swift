//
//  CustSOC+DeleteSOC.swift
//
//
//  Created by Victor Cantu on 11/6/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustSOCComponents {
    
    static func deleteSOC(
        socId: UUID,
        callback: @escaping ( (_ resp: APIResponse?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "deleteSOC",
            DeleteSOCRequest(
                socId: socId
            )
        ) { data in
            guard let data else{
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

