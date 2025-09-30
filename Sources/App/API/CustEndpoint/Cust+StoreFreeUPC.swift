//
//  Cust+StoreFreeUPC.swift
//  
//
//  Created by Victor Cantu on 9/18/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustAPIEndpointV1 {
        
    static func storeFreeUPC(
        code: String,
        brand: String,
        isRental: Bool,
        id: UUID?,
        callback: @escaping ( (_ resp: APIResponseGeneric<StoreFreeTermResponse>?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "storeFreeUPC",
            StoreFreeTermRequest(
                code: code,
                brand: brand,
                isRental: isRental,
                id: id
            )
        ) { payload in
            
            guard let data = payload else{
                callback(nil)
                return
            }
            
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<StoreFreeTermResponse>.self, from: data)
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
