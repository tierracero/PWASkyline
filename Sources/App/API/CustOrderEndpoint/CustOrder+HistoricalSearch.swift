//
//  CustOrder+HistoricalSearch.swift
//  
//
//  Created by Victor Cantu on 7/2/22.
//

import Foundation
import TCFundamentals
import TCFireSignal
import TCFundamentals

extension CustOrderComponents {
    
    static func historicalSearch (
        accountid: HybridIdentifier?,
        tag1: String,
        tag2: String,
        tag3: String,
        tag4: String,
        description: String,
        timeEnd: Int64,
        timeInit: Int64,
        callback: @escaping ( (_ resp: APIResponseGeneric<HistoricalSearchResponse>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "historicalSearch",
            HistoricalSearchRequest(
                accountid: accountid,
                tag1: tag1,
                tag2: tag2,
                tag3: tag3,
                tag4: tag4,
                description: description,
                timeEnd: timeEnd,
                timeInit: timeInit
            )
        ) { resp in
            guard let data = resp else{
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<HistoricalSearchResponse>.self, from: data)
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
