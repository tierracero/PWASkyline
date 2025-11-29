//
//  Cust+GetTCSOCAvailableServices.swift
//  
//
//  Created by Victor Cantu on 10/10/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustComponents {
    
    static func getTCSOCAvailableServices(
        efect: [BillingEfect],
        callback: @escaping ( (
            _ resp: APIResponseGeneric<[CustTCSOCObject]>?
        ) -> () )
    ) {
        sendPost(
            rout,
            version,
            "getTCSOCAvailableServices",
            GetTCSOCAvailableServicesRequest(
                efect: efect
            )
        ) { payload in
            guard let data = payload else{
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<[CustTCSOCObject]>.self, from: data)
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

