//
//  Cust+GetFianancialServices.swift
//  
//
//  Created by Victor Cantu on 8/7/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustComponents {
    
    static func getFianancialServices(
        callback: @escaping ( (_ resp: APIResponseGeneric<[CustUserFinacialServicesQuick]>?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "getFianancialServices",
            EmptyPayload()
        ) { data in
            guard let data else{
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<[CustUserFinacialServicesQuick]>?.self, from: data)
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

