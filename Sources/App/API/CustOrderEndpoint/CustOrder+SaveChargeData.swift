//
//  CustOrder+SaveChargeData.swift
//  
//
//  Created by Victor Cantu on 7/13/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustOrderComponents {
    
    static func saveChargeData (
        type: ChargeType,
        orderId: UUID,
        ids: [UUID],
        units: Int64,
        cost: Int64,
        price: Int64,
        name: String,
        fiscCode: String,
        fiscUnit: String,
        callback: @escaping ( (_ resp: APIResponse?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "saveChargeData",
            SaveChargeDataRequest(
                type: type, 
                orderId: orderId,
                ids: ids,
                units: units,
                cost: cost,
                price: price,
                name: name,
                fiscCode: fiscCode,
                fiscUnit: fiscUnit
            )
        ) { resp in
            guard let data = resp else{
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
