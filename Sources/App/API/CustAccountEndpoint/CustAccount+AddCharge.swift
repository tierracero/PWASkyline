//
//  CustAccount+AddCharge.swift
//  
//
//  Created by Victor Cantu on 12/20/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustAccountComponents {
    
    public static func addCharge(
        socid: UUID,
        accountid: UUID,
        price: Int64,
        callback: @escaping ( (
            _ resp: APIResponseGeneric<CustAcctChargesQuick>?
        ) -> () )) {
        
        sendPost(
            rout,
            version,
            "addCharge",
            AddChargeRequest(
                socid: socid,
                accountid: accountid,
                price: price
            )
        ) { payload in
            
            guard let data = payload else{
                callback(nil)
                return
            }
            
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<CustAcctChargesQuick>.self, from: data)
                callback(resp)
            }
            catch{
                print("⭕️ load \(#function)")
                print(error)
                callback(nil)
            }
        }
    }
}


