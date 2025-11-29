//
//  Cust+POCInventoryDetails.swift
//  
//
//  Created by Victor Cantu on 7/21/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustComponents {
    
    static func pocInventoryDetails(
        id: UUID,
        callback: @escaping ( (_ resp: APIResponseGeneric<PocInventoryDetailsResponse>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "pocInventoryDetails",
            PocInventoryDetailsRequest(
                id: id
            )
        ) { payload in
            guard let data = payload else{
                callback(nil)
                return
            }
            do{
                
                let resp = try JSONDecoder().decode(APIResponseGeneric<PocInventoryDetailsResponse>.self, from: data)
                callback(resp)
                
            }
            catch{
                print(error)
                callback(nil)
            }
        }
    }
}
