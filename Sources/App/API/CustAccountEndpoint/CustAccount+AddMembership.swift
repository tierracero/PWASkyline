//
//  CustAccount+AddMembership.swift
//  
//
//  Created by Victor Cantu on 2/13/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustAccountComponents {
    
    public static func addMembership(
        storeId: UUID,
        accountid: UUID,
        socid: UUID,
        socName: String,
        price: Int64,
        code: FiscalPaymentCodes,
        description: String,
        amount: Int64,
        provider: String,
        auth: String,
        lastFour: String,
        starAt: Int64,
        expiredAt: Int64,
        callback: @escaping ( (_ resp: APIResponseGeneric<AddMembershipResponse>?) -> () )) {
        
        sendPost(
            rout,
            version,
            "addMembership",
            AddMembershipRequest(
                storeId: storeId,
                accountid: accountid,
                socid: socid,
                socName: socName,
                price: price,
                code: code,
                description: description,
                amount: amount,
                provider: provider,
                auth: auth,
                lastFour: lastFour,
                startAt: starAt,
                expiredAt: expiredAt
            )
        ) { payload in
            
            guard let data = payload else{
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<AddMembershipResponse>.self, from: data)
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


