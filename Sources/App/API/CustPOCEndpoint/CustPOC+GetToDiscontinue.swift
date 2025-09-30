//
//  CustPOC+GetToDiscontinue.swift
//  
//
//  Created by Victor Cantu on 3/6/25.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustPOCEndpointV1 {
    
    static func getToDiscontinue(
        limit: Int,
        callback: @escaping ( (_ resp: APIResponseGeneric<[GetToDiscontinueItem]>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "getToDiscontinue",
            GetToDiscontinueRequest(
                limit: limit
            )
        ) { data in
            guard let data else{
                callback(nil)
                return
            }
            do{
                callback(try JSONDecoder().decode(APIResponseGeneric<[GetToDiscontinueItem]>.self, from: data))
            }
            catch{
                print(error)
                callback(nil)
            }
        }
    }
}
