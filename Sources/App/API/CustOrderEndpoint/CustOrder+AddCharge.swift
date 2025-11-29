//
//  CustOrder+AddCharge.swift
//
//
//  Created by Victor Cantu on 7/9/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustOrderComponents {
    
    ///  Send OrderID to retive notes
    static func addCharge (
        orderId: UUID,
        item: AddChargeType,
        callback: @escaping ( (_ resp: APIResponseGeneric<API.custOrderV1.AddChargeResponse>?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "addCharge",
            AddChargeRequest(
                 orderId: orderId,
                item: item
            )
        ) { data in
            
            guard let data else {
                
                callback(nil)
                return
            }
            do{
                callback(try JSONDecoder().decode(APIResponseGeneric<API.custOrderV1.AddChargeResponse>.self, from: data))
            }
            catch{
                print("🔴 API_DECODING_ERROR")
                print(error)
                callback(nil)
            }
        }
        
    }
}

