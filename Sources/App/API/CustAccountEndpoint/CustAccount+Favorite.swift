//
//  CustAccount+Favorite.swift
//
//
//  Created by Victor Cantu on 7/25/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustAccountComponents {
    
    public static func favorite(
        callback: @escaping ( (_ resp: APIResponseGeneric<[CustAcctQuick]>?) -> () )) {
        
        sendPost(
            rout,
            version,
            "favorite",
            EmptyPayload()
        ) { data in
            
            guard let data else{
                callback(nil)
                return
            }
            do{
                callback(try decodeAPIResponse(APIResponseGeneric<[CustAcctQuick]>.self, from: data))
            }
            catch{
                print("⭕️ load \(#function)")
                print(error)
                callback(nil)
            }
        }
    }
}
