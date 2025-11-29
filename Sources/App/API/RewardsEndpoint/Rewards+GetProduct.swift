//
//  Rewards+GetProduct.swift
//
//
//  Created by Victor Cantu on 5/22/24.
//

import Foundation
import TCFundamentals
import TCFireSignal
import TaecelAPICore

extension RewardsComponents {
    
    public static func getProduct(
        taecelId: String,
        callback: @escaping ( (_ resp: APIResponseGeneric<GetProductResponse>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "getProduct",
            GetProductRequest(
                taecelId: taecelId
            )
        ) { data in
            guard let data else{
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<GetProductResponse>.self, from: data)
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
