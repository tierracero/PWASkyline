//
//  Cust+GetVendor.swift
//  
//
//  Created by Victor Cantu on 2/1/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustComponents {
        
    static func getVendor(
        id: UUID,
        callback: @escaping ((_ resp: APIResponseGeneric<CustVendorsQuick>?) -> ())
    ) {
        sendPost(
            rout,
            version,
            "getVendor",
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
                let resp = try JSONDecoder().decode(APIResponseGeneric<CustVendorsQuick>.self, from: data)
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

