//
//  Cust+DailyCut.swift
//  
//
//  Created by Victor Cantu on 7/3/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustComponents {
    
    static func dailyCut(
        id: UUID?,
        callback: @escaping ( (_ resp: APIResponseGeneric<DailyCutResponse>?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "dailyCut",
            DailyCutRequest(
                id: id
            )
        ) { payload in
            
            guard let payload else{
                callback(nil)
                return
            }
            
            do {
                callback(try JSONDecoder().decode(APIResponseGeneric<DailyCutResponse>.self, from: payload))
            }
            catch{
                print("🔴 API_DECODING_ERROR")
                print(error)
                callback(nil)
            }
            
        }
    }
}
