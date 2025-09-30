//
//  CustOrder+MarkFolioAsRead.swift
//  
//
//  Created by Victor Cantu on 4/6/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustOrderEndpointV1 {
    
    static func markFolioAsRead (
        orderid: UUID,
        callback: @escaping ( (_ resp: APIResponseGeneric<MarkFolioAsReadResponse>?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "markFolioAsRead",
            MarkFolioAsReadRequest(orderid: orderid)
        ) { resp in
            guard let data = resp else{
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<MarkFolioAsReadResponse>.self, from: data)
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

