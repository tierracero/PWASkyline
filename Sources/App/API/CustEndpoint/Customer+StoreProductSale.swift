//
//  Customer+StoreProductSale.swift
//
//
//  Created by Victor Cantu on 2/21/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustComponents {
    
    
    static func storeProductSale(
        pocId: UUID,
        accountId: UUID?,
        callback: @escaping ( (_ resp: APIResponseGeneric<StoreProductSaleResponse>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "storeProductSale",
            StoreProductSaleRequest(
                pocId: pocId,
                accountId: accountId
            )
        ) { data in
            guard let data else {
                callback(nil)
                return
            }
            do{
                callback(try decodeAPIResponse(APIResponseGeneric<StoreProductSaleResponse>.self, from: data))
            }
            catch{
                print("🔴  🔴  🔴  🔴  🔴  🔴  🔴  🔴  🔴  🔴  🔴  🔴  🔴  🔴")
                print(#function)
                print(error)
                callback(nil)
            }
        }
    }
}
