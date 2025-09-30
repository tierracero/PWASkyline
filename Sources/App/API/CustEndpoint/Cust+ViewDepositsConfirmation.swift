//
//  Cust+ViewDepositsConfirmation.swift
//  
//
//  Created by Victor Cantu on 7/6/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustAPIEndpointV1 {
        
    static func viewDepositsConfirmation(
        id: UUID?,
        callback: @escaping ( (_ resp: APIResponseGeneric<ViewDepositsConfirmationResponse>?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "viewDepositsConfirmation",
            ViewDepositsConfirmationRequest(
                id: id
            )
        ) { payload in
            
            guard let data = payload else{
                callback(nil)
                return
            }
            
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<ViewDepositsConfirmationResponse>.self, from: data)
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
