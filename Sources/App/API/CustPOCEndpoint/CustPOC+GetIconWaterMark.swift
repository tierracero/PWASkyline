//
//  CustPOC+GetIconWaterMark.swift
//  
//
//  Created by Victor Cantu on 9/22/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustPOCComponents {
    
    static func getIconWaterMark(
        callback: @escaping ( (_ resp: APIResponseGeneric<[CustWebFiles]>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "getIconWaterMark",
            EmptyPayload()
        ) { payload in
            guard let data = payload else{
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<[CustWebFiles]>.self, from: data)
                callback(resp)
            }
            catch{
                print(error)
                callback(nil)
            }
        }
    }
}

