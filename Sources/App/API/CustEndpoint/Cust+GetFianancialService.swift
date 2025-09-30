//
//  Cust+GetFianancialService.swift
//  
//
//  Created by Victor Cantu on 7/28/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustAPIEndpointV1 {
    
    static func getFianancialService(
        id: HybridIdentifier,
        callback: @escaping ( (_ resp: APIResponseGeneric<GetFianancialServiceResponse>?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "getFianancialService",
            GetFianancialServiceRequest(
                id: id
            )
        ) { payload in
            guard let data = payload else{
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<GetFianancialServiceResponse>?.self, from: data)
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
