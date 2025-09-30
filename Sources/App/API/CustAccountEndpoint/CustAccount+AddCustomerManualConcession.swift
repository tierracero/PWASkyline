//
//  CustAccount+AddCustomerManualConcession.swift
//
//
//  Created by Victor Cantu on 7/12/24.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustAccountEndpointV1 {
    
    public static func addCustomerManualConcession(
        storeId: UUID,
        accountId: UUID,
        items: [SaleObjectItem],
        callback: @escaping ( (_ resp: APIResponseGeneric<AddCustomerManualConcessionResponse>?) -> () )) {
        
        sendPost(
            rout,
            version,
            "addCustomerManualConcession",
            AddCustomerManualConcessionRequest(
                storeId: storeId,
                accountId: accountId,
                items: items
            )
        ) { data in
            
            guard let data else{
                callback(nil)
                return
            }
            
            do{
                callback(try JSONDecoder().decode(APIResponseGeneric<AddCustomerManualConcessionResponse>.self, from: data))
            }
            catch{
                print("⭕️ load \(#function)")
                print(error)
                callback(nil)
            }
            
        }
    }
}
