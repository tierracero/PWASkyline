//
//  CustPOC+GetTransferOrders.swift
//  
//
//  Created by Victor Cantu on 4/28/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustPOCEndpointV1 {
    
    static func getTransferOrders(
        type: GetTransferOrdersType,
        callback: @escaping ( (_ resp: APIResponseGeneric<GetTransferOrdersResponse>?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "getTransferOrders",
            GetTransferOrdersRequest(
                type: type
            )
        ) { payload in
            
            guard let payload else{
                callback(nil)
                return
            }
            
            
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<GetTransferOrdersResponse>.self, from: payload)
                callback(resp)
            }
            catch{
                print(error)
                callback(nil)
            }
        }
    }
}
