//
//  CustOrder+Archive.swift
//
//
//  Created by Victor Cantu on 7/1/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustOrderEndpointV1 {
    
    @available(*, deprecated, message: "Replace with CustOrder+ChangeStatus")
    static func archive (
        orderid: UUID,
        callback: @escaping ( (_ resp: APIResponseGeneric<ArchiveResponse>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "archive",
            ArchiveRequest(orderid: orderid)
        ) { resp in
            guard let data = resp else{
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<ArchiveResponse>.self, from: data)
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

