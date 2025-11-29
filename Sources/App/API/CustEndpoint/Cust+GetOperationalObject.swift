//
//  Cust+GetOperationalObject.swift
//
//
//  Created by Victor Cantu on 11/12/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustComponents {
    
    static func getOperationalObject (
        id: HybridIdentifier,
        callback: @escaping ( (_ resp: APIResponseGeneric<GetOperationalObjectResponse>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "getOperationalObject",
            GetOperationalObjectRequest(
                id: id
            )
        ) { data in
            guard let data else{
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<GetOperationalObjectResponse>.self, from: data)
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
