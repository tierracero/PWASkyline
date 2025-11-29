//
//  CustOrder+GetCharges.swift
//  
//
//  Created by Victor Cantu on 3/15/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustOrderComponents {
    
    static func getCharges (
        orderid: UUID,
        callback: @escaping ( (_ resp: APIResponseGeneric<GetChargesResponse>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "getCharges",
            GetChargesRequest(
                orderid: orderid
            )
        ) { resp in
            guard let data = resp else{
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<GetChargesResponse>.self, from: data)
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

