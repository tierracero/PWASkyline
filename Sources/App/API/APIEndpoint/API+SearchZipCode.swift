//
//  API+SearchZipCode.swift
//  
//
//  Created by Victor Cantu on 10/24/24.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension APIComponents {

    static func searchZipCode(
        code: String,
        country: Countries,
        callback: @escaping ( (_ resp: APIResponseGeneric<[PostalCodesMexicoItem]>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "searchZipCode",
            SearchZipCodeRequest(
                code: code,
                country: country
            )
        ) { data in
            guard let data else{
                callback(nil)
                return
            }
            do{
                callback(try decodeAPIResponse(APIResponseGeneric<[PostalCodesMexicoItem]>.self, from: data))
            }
            catch{
                print("🔴 API_DECODING_ERROR")
                print(error)
                callback(nil)
            }
        }
    }
}

