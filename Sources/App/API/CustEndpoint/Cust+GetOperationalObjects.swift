//
//  Cust+GetOperationalObjects.swift
//  
//
//  Created by Victor Cantu on 11/13/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustComponents {
    
    static func getOperationalObjects (
        callback: @escaping ( (_ resp: APIResponseGeneric<[CustSOCActionOperationalObjectQuick]>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "getOperationalObjects",
            EmptyPayload()
        ) { data in
            
            guard let data else{
                callback(nil)
                return
            }
            
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<[CustSOCActionOperationalObjectQuick]>.self, from: data)
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
