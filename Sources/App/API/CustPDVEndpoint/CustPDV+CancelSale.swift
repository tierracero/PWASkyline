//
//  CustPDV+CancelSale.swift
//  
//
//  Created by Victor Cantu on 7/24/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustPDVEndpointV1 {
    
    static func cancelSale(
        type: SaleCancelationType,
        saleid: UUID,
        reason: String,
        refundTo: UUID?,
        callback: @escaping ((
            _ resp: APIResponse?
        ) -> ())
    ) {
        
        sendPost(
            rout,
            version,
            "cancelSale",
            CancelSaleRequest(
                type: type,
                saleid: saleid,
                reason: reason,
                refundTo: refundTo
            )
        ) { resp in
            
                guard let data = resp else {
                    callback(nil)
                    return
                }
            
                do{
                    let resp = try JSONDecoder().decode(APIResponse.self, from: data)
                    callback(resp)
                }
                catch{
                    print(error)
                    callback(nil)
                }
            }
    }
}
