//
//  Rewards+GetProducts.swift
//
//
//  Created by Victor Cantu on 2/18/24.
//

import Foundation
import TCFundamentals
import TCFireSignal
import TaecelAPICore

extension RewardsEndpointV1 {
    
    public static func getProducts(
        carrierId: String,
        callback: @escaping ( (_ resp: APIResponseGeneric<GetProductsResponse>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "getProducts",
            GetProductsRequest(
                carrierId: carrierId
            )
        ) { payload in
            guard let data = payload else{
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<GetProductsResponse>.self, from: data)
                callback(resp)
            }
            catch{
                print("⭕️ loadFIAccounts")
                print(error)
                callback(nil)
            }
        }
    }
}
