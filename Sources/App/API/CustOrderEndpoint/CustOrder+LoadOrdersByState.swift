//
//  CustOrder+LoadOrdersByState.swift
//
//
//  Created by Victor Cantu on 10/27/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustOrderEndpointV1 {
    
    static func loadOrdersByState (
        state: OrderState,
        store: UUID?,
        account: UUID?,
        callback: @escaping ( (_ resp: APIResponseGeneric<LoadOrdersByStateResponse>?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "loadOrdersByState",
            LoadOrdersByStateRequest(
                state: state,
                store: store,
                account: account
            )
        ) { data in
            guard let data else{
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<LoadOrdersByStateResponse>.self, from: data)
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

