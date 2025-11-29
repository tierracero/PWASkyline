//
//  CustPOC+GetMerms.swift
//  
//
//  Created by Victor Cantu on 7/28/25. 
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustPOCComponents {
    
    static func getMerms(
        store: UUID,
        startAt: Int64,
        endAt: Int64,
        callback: @escaping ( (_ resp: APIResponseGeneric<GetMermsResponse>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "getMerms",
            GetMermsRequest(
                store: store,
                startAt: startAt,
                endAt: endAt
            )
        ) { data in
            guard let data else {
                callback(nil)
                return
            }
            do{
                callback(try JSONDecoder().decode(APIResponseGeneric<GetMermsResponse>.self, from: data))
            }
            catch{
                print("🔴 decoding error")
                print(#function)
                print(error)
                callback(nil)
            }
        }
    }
}
