// DELETEME
//  Cust+ConfirmConfirmartionSMS.swift
//  
//
//  Created by Victor Cantu on 5/25/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustAPIEndpointV1 {
    
    public static func confirmConfirmartionSMS(
        tokens: [String],
        pin: String,
        mobile: String,
        customer: ConfirmConfirmartionCustomer?,
        callback: @escaping ( (_ resp: APIResponseGeneric<ConfirmConfirmartionSMSResponse>?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "confirmConfirmartionSMS",
            
            ConfirmConfirmartionSMSRequest(
                tokens: tokens,
                pin: pin,
                mobile: mobile,
                customer: customer
            )
            
        ) { payload in
            guard let payload else{
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<ConfirmConfirmartionSMSResponse>.self, from: payload)
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
