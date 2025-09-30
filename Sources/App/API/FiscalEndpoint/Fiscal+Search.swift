//
//  Fiscal+Search.swift
//  
//
//  Created by Victor Cantu on 4/3/24.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension FiscalEndpointV1 {
    
    static func search(
        emisorRfc: String,
        term: String,
        callback: @escaping ( (_ resp: APIResponseGeneric<SearchResponse>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "search",
            SearchRequest(
                emisorRfc: emisorRfc,
                term: term
            )
        ) { payload in
            
            guard let data = payload else{
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<SearchResponse>.self, from: data)
                callback(resp)
            }
            catch{
                print(error)
                callback(nil)
            }
        }
        
    }
}
