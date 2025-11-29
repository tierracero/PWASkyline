//
//  CustPDV+GetSale.swift
//  
//
//  Created by Victor Cantu on 3/20/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustPDVComponents {
    
    static func getSale(
        saleId: HybridIdentifier,
        callback: @escaping ((
            _ resp: APIResponseGeneric<GetSaleResponse>?) -> ()
        )
    ) {
        
        sendPost(
            rout,
            version,
            "getSale",
            GetSaleRequest(
                saleId: saleId
            )
        ) { resp in
            
                guard let data = resp else {
                    callback(nil)
                    return
                }
            
                do{
                    let resp = try JSONDecoder().decode(APIResponseGeneric<GetSaleResponse>.self, from: data)
                    callback(resp)
                }
                catch{
                    print(error)
                    callback(nil)
                }
            
            }
    }
}
