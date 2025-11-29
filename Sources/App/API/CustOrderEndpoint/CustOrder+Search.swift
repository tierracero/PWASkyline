//
//  CustOrder+Search.swift
//
//
//  Created by Victor Cantu on 11/5/24.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustOrderComponents {
    
    static func search (
        term: String,
        onlyActive: Bool,
        callback: @escaping ( (_ resp: APIResponseGeneric<SearchResponse>?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "search",
            SearchRequest(
                term: term,
                onlyActive: onlyActive
            )
            
        ) { data in
            guard let data else {
                callback(nil)
                return
            }
            do{
                callback(try JSONDecoder().decode(APIResponseGeneric<SearchResponse>.self, from: data))
            }
            catch{
                print("🔴 API_DECODING_ERROR")
                print(error)
                callback(nil)
            }
        }
    }
}

