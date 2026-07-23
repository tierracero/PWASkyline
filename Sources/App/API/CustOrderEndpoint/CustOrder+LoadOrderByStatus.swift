//
//  CustOrder+LoadOrderByStatus.swift
//
//
//  Created by Victor Cantu on 10/26/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustOrderComponents {
    
    static func loadOrderByStatus (
        status: CustFolioStatus,
        store: UUID?,
        account: UUID?,
        callback: @escaping ( (_ resp: APIResponseGeneric<LoadOrderByStatusResponse>?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "loadOrderByStatus",
            LoadOrderByStatusRequest(
                status: status,
                store: store,
                account: account
            )
        ) { resp in
            guard let data = resp else{
                callback(nil)
                return
            }
            do{
                let resp = try decodeAPIResponse(APIResponseGeneric<LoadOrderByStatusResponse>.self, from: data)
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
