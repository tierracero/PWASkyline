//
//  Cust+CustomePrintEngine.swift
//  SkylineServer
//
//  Created by Victor Cantu on 2/12/26.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustComponents {
    
    static func customePrintEngine(
        storeId: UUID?,
        scriptId: UUID,
        fileName: String,
        payload: CustomePrintEngineType,
        callback: @escaping ( (_ resp: APIResponseGeneric<CustomePrintEngineResponse>?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "customePrintEngine",
            CustomePrintEngineRequest(
                storeId: storeId,
                scriptId: scriptId,
                fileName: fileName,
                payload: payload
            )
        ) { data in
            
            guard let data else{
                callback(nil)
                return
            }
            
            do {
                callback(try JSONDecoder().decode(APIResponseGeneric<CustomePrintEngineResponse>.self, from: data))
            }
            catch{
                print("🔴 API_DECODING_ERROR")
                print(error)
                callback(nil)
            }
            
        }
    }
}
