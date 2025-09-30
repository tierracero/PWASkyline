//
//  Cust+SaveConfigs.swift
//  
//
//  Created by Victor Cantu on 9/15/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustAPIEndpointV1 {
    
    static func saveConfigs(
        configStoreProcessing: ConfigStoreProcessing?,
        configContactTags: ConfigContactTags?,
        configServiceTags: ConfigServiceTags?,
        configGeneral: ConfigGeneral?,
        callback: @escaping ( (_ resp: APIResponse?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "saveConfigs",
            SaveConfigsRequest(
                configStoreProcessing: configStoreProcessing,
                configContactTags: configContactTags,
                configServiceTags: configServiceTags,
                configGeneral: configGeneral
            )
        ) { payload in
            
            guard let data = payload else{
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
