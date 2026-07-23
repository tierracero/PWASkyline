//
//  CustOrder+GetOrderManagerItems.swift
//  
//
//  Created by Victor Cantu on 8/15/22.
//


import Foundation
import TCFundamentals
import TCFireSignal

extension CustOrderComponents {
    
    ///  Send OrderID to retive notes
    static func getOrderManagerItems (
        callback: @escaping ( (_ resp: APIResponseGeneric<GetOrderManagerItemsResponse>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "getOrderManagerItems",
            EmptyPayload()
        ) { resp in
            guard let data = resp else{
                callback(nil)
                return
            }
            do{
                let resp = try decodeAPIResponse(APIResponseGeneric<GetOrderManagerItemsResponse>.self, from: data)
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

