//
//  Cust+GetUsedFiscCode.swift
//
//
//  Created by Victor Cantu on 7/11/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustComponents {
        
    static func getUsedFiscCode(
        type: ChargeType,
        callback: @escaping ( (_ resp: [APISearchResultsGeneral]?) -> () )
    ){
        sendPost(
            rout,
            version,
            "getUsedFiscCode",
            GetUsedFiscCodeRequest(
                type: type
            )
        ) { payload in
            
            guard let data = payload else{
                callback(nil)
                return
            }
            
            do{
                let resp = try decodeAPIResponse([APISearchResultsGeneral].self, from: data)
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
