//
//  CustOrder+UpdateCustProjectItemValue.swift
//
//
//  Created by Victor Cantu on 10/3/24.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustOrderComponents {
    static func updateCustProjectItemValue(
        itemId: UUID,
        value: String,
        callback: @escaping ( (_ resp: APIResponse?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "updateCustProjectItemValue",
            UpdateCustProjectItemValueRequest(
                itemId: itemId,
                value: value
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
