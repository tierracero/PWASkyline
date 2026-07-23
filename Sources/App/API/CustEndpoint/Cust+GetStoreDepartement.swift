//
//  Cust+GetStoreDepartement.swift
//  
//
//  Created by Victor Cantu on 1/30/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustComponents {
        
    static func getStoreDepartement(
        id: UUID,
        callback: @escaping ( (_ resp: APIResponseGeneric<CustStoreDepsAPI>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "getStoreDepartement",
            APIRequestID(
                id: id,
                store: nil
            )
        ) { payload in
            
            guard let data = payload else{
                callback(nil)
                return
            }
            
            do{
                let resp = try decodeAPIResponse(APIResponseGeneric<CustStoreDepsAPI>.self, from: data)
                
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
