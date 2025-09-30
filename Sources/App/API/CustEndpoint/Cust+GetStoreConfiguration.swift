//
//  Cust+GetStoreConfiguration.swift
//
//
//  Created by Victor Cantu on 6/8/24.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustAPIEndpointV1 {
        
    static func getStoreConfiguration(
        storeId: UUID,
        callback: @escaping ( (_ resp: APIResponseGeneric<GetStoreConfigurationResponse>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "getStoreConfiguration",
            GetStoreConfigurationRequest(
                storeId: storeId
            )
        ) { data in
            
            guard let data else {
                callback(nil)
                return
            }
            
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<GetStoreConfigurationResponse>.self, from: data)
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
