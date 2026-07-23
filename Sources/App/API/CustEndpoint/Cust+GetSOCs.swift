//
//  Cust+GetSOCs.swift
//  
//
//  Created by Victor Cantu on 2/12/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustComponents {
        
    static func getSOCs(
        type: SOCCodeType?,
        callback: @escaping ( (_ resp: APIResponseGeneric<[CustSOC]>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "getSOCs",
            GetSOCsRequest(
                type: type
            )
        ) { payload in
            
            guard let data = payload else{
                callback(nil)
                return
            }
            
            do{
                
                let resp = try decodeAPIResponse(APIResponseGeneric<[CustSOC]>.self, from: data)
                
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

