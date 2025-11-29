//
//  Cust+SendConfirmartionSMS.swift
//  
//
//  Created by Victor Cantu on 5/25/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustComponents {
    
    public static func sendConfirmartionSMS(
        hCaptchResponse: String,
        firstName: String,
        cc: Countries,
        mobile: String,
        callback: @escaping ( (_ resp: APIResponseGeneric<SendConfirmartionSMSResponse>?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "sendConfirmartionSMS",
            
            SendConfirmartionSMSRequest(
                hCaptchResponse: hCaptchResponse,
                firstName: firstName,
                cc: cc,
                mobile: mobile
            )
        ) { payload in
            guard let data = payload else{
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<SendConfirmartionSMSResponse>.self, from: data)
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

