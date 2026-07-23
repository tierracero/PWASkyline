//
//  Cust+ChangePrice.swift
//  
//
//  Created by Victor Cantu on 5/9/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustComponents {
    
    static func changePrice(
        type: ChargeType,
        id: UUID,
        requestedPrice: Int64,
        reason: String,
        callback: @escaping ( (_ resp: APIResponseGeneric<ChangePriceResponse>?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "changePrice",
            ChangePriceRequest(
                type: type,
                id: id,
                requestedPrice: requestedPrice,
                reason: reason
            )
        ) { payload in
            guard let data = payload else{
                callback(nil)
                return
            }
            do{
                let resp = try decodeAPIResponse(APIResponseGeneric<ChangePriceResponse>.self, from: data)
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

