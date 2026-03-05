//
//  CustOrder+AddLocation.swift
//  SkylineServer
//
//  Created by Victor Cantu on 3/4/26.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustOrderComponents {
    
    static func addLocation (
        latitude: Double,
        longitude: Double,
        orderId: UUID,
        callback: @escaping ( (_ resp: APIResponse?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "addLocation",
            AddLocationRequest(
                latitude: latitude,
                longitude: longitude,
                orderId: orderId
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

