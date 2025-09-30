//
//  API+GetFiscalDangerousMaterial.swift
//  
//
//  Created by Victor Cantu on 1/12/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension APIEndpointV1 {

    static func getFiscalDangerousMaterial(
        code: String,
        callback: @escaping ( (_ resp: APIResponseGeneric<GetFiscalCodeResponse>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "getFiscalDangerousMaterial",
            GetFiscalCodeRequest(code: code)
        ) { resp in
            guard let data = resp else{
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<GetFiscalCodeResponse>.self, from: data)
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

