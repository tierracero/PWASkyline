//
//  Cust+PaymentAuthPreValidation.swift
//  
//
//  Created by Victor Cantu on 10/24/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustAPIEndpointV1 {
        
    static func paymentAuthPreValidation(
        formaDePago: FiscalPaymentCodes,
        provider: String,
        auth: String,
        lastFour: String,
        callback: @escaping ( (_ resp: APIResponseGeneric<PaymentAuthPreValidationResponse>?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "paymentAuthPreValidation",
            PaymentAuthPreValidationRequest(
                formaDePago: formaDePago,
                provider: provider,
                auth: auth,
                lastFour: lastFour
            )
        ) { payload in
            
            guard let data = payload else{
                callback(nil)
                return
            }
            
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<PaymentAuthPreValidationResponse>.self, from: data)
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
