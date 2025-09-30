//
//  Cust+GetMoneyManager.swift
//  
//
//  Created by Victor Cantu on 7/13/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustAPIEndpointV1 {
        
    static func getMoneyManager(
        id: HybridIdentifier,
        callback: @escaping ( (_ resp: APIResponseGeneric<GetMoneyManagerResponse>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "getMoneyManager",
            GetMoneyManagerRequest(
                id: id
            )
        ) { payload in
            
            guard let payload else{
                callback(nil)
                return
            }
            
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<GetMoneyManagerResponse>.self, from: payload)
                
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
