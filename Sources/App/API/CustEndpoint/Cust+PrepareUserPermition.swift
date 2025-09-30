//
//  Cust+PrepareUserPermition.swift
//
//
//  Created by Victor Cantu on 6/28/24.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustAPIEndpointV1 {
    
    static func prepareUserPermition(
        callback: @escaping ( (_ resp: APIResponseGeneric<PrepareUserPermitionResponse>?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "prepareUserPermition",
            EmptyPayload()
        ) { data in
            guard let data else {
                callback(nil)
                return
            }
            do{
                callback(try JSONDecoder().decode(APIResponseGeneric<PrepareUserPermitionResponse>.self, from: data))
            }
            catch{
                print(error)
                callback(nil)
            }
        }
    }
}
