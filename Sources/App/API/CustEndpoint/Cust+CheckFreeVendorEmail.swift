//
//  Cust+CheckFreeVendorEmail.swift
//  
//
//  Created by Victor Cantu on 11/22/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustAPIEndpointV1 {
    
    static func checkFreeVendorEmail(
        email: String,
        accountid: UUID?,
        callback: @escaping ( (_ resp: APIResponseGeneric<CheckFreeVendorResponse>?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "checkFreeVendorEmail",
            CheckFreeVendorEmailRequest(
                email: email,
                accountid: accountid
            )
        ) { payload in
            guard let data = payload else{
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<CheckFreeVendorResponse>.self, from: data)
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

