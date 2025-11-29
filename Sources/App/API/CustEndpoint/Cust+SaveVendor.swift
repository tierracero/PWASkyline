//
//  Cust+SaveVendor.swift
//  
//
//  Created by Victor Cantu on 2/1/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustComponents {
    
    static func saveVendor(
        id: UUID,
        businessName: String,
        firstName: String,
        lastName: String,
        rfc: String,
        razon: String,
        email: String,
        mobile: String,
        fiscalPOCMobile: String,
        creditDays: Int64,
        callback: @escaping ( (_ resp: APIResponse?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "saveVendor",
            SaveVendorRequest(
                id: id,
                businessName: businessName,
                firstName: firstName,
                lastName: lastName,
                rfc: rfc,
                razon: razon,
                email: email,
                mobile: mobile,
                fiscalPOCMobile: fiscalPOCMobile,
                creditDays: creditDays
            )
        ) { payload in
            guard let data = payload else{
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponse.self, from: data)
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
