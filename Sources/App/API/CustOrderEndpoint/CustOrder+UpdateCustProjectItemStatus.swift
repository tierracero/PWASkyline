//
//  CustOrder+UpdateCustProjectItemStatus.swift
//  
//
//  Created by Victor Cantu on 10/3/24.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustOrderComponents {
    static func updateCustProjectItemStatus(
        itemId: UUID,
        status: CustOrderProjetcManagerItemStatus,
        callback: @escaping ( (_ resp: APIResponse?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "updateCustProjectItemStatus",
            UpdateCustProjectItemStatusRequest(
                itemId: itemId,
                status: status
            )
        ) { data in
            guard let data else{
                callback(nil)
                return
            }
            do{
                callback(try JSONDecoder().decode(APIResponse.self, from: data))
            }
            catch{
                print("🔴 API_DECODING_ERROR")
                print(error)
                callback(nil)
            }
        }
    }
}
