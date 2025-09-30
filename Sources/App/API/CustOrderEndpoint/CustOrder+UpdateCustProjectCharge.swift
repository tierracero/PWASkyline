//
//  CustOrder+UpdateCustProjectCharge.swift
//  
//
//  Created by Victor Cantu on 10/3/24.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustOrderEndpointV1 {
    static func updateCustProjectCharge(
        chargeId: UUID,
        units: Int,
        cost: Int64,
        callback: @escaping ( (_ resp: APIResponse?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "updateCustProjectCharge",
            UpdateCustProjectChargeRequest(
                chargeId: chargeId,
                units: units,
                cost: cost
            )
        ) { data in
            guard let data else{
                callback(nil)
                return
            }
            do{
                callback(try JSONDecoder().decode(APIResponse.self, from: data))
            }
            catch{
                print("🔴 API_DECODING_ERROR")
                print(error)
                callback(nil)
            }
        }
    }
}
