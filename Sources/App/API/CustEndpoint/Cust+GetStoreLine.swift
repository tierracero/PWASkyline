//
//  Cust+GetStoreLine.swift
//  
//
//  Created by Victor Cantu on 1/30/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustAPIEndpointV1 {
        
    static func getStoreLine(
        id: UUID,
        callback: @escaping ( (_ resp: APIResponseGeneric<CustStoreLinesAPI>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "getStoreLine",
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
                let resp = try JSONDecoder().decode(APIResponseGeneric<CustStoreLinesAPI>.self, from: data)
                
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
