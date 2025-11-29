//
//  CustOrder+SearchFolio.swift
//  
//
//  Created by Victor Cantu on 7/24/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustOrderComponents {
    
    static func searchFolio (
        term: String,
        accountid: UUID?,
        tag1: String?,
        tag2: String?,
        tag3: String?,
        tag4: String?,
        description: String?,
        startAt: Int64?,
        endAt: Int64?,
        callback: @escaping ( (_ resp: APIResponseGeneric<SearchFolioResponse>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "searchFolio",
            SearchFolioRequest(
                term: term,
                accountid: accountid,
                tag1: tag1,
                tag2: tag2,
                tag3: tag3,
                tag4: tag4,
                description: description,
                startAt: startAt,
                endAt: endAt
            )
            
        ) { resp in
            guard let data = resp else{
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<SearchFolioResponse>.self, from: data)
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

