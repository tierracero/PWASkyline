// DELETEME
//  Cust+SendContactForm.swift
//  
//
//  Created by Victor Cantu on 5/23/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
/*
extension CustComponents {
        
    public static func sendContactForm(
        hCaptchResponse: String,
        firstName: String,
        lastName: String,
        mobile: String,
        email: String,
        what: String,
        callback: @escaping ( (_ resp: APIResponse?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "sendContactForm",
            SendContactFormRequest(
                hCaptchResponse: hCaptchResponse,
                firstName: firstName,
                lastName: lastName,
                mobile: mobile,
                email: email,
                what: what
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
*/
