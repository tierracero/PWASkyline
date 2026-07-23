//
//  CustOrder+GetWorkLoadPromis.swift
//  
//
//  Created by Victor Cantu on 7/14/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustOrderComponents {
    
    ///  Send OrderID to retive notes
    static func getWorkLoadPromis (
        storeid: UUID,
        callback: @escaping ( (_ resp: APIResponseGeneric<GetWorkLoadPromisResponse>?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "getWorkLoadPromis",
            APIRequestID(id: storeid, store: nil)
        ) { resp in
            guard let data = resp else {
                callback(nil)
                return
            }
            do{
                let resp = try decodeAPIResponse(APIResponseGeneric<GetWorkLoadPromisResponse>.self, from: data)
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

