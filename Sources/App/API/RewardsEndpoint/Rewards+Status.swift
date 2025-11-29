//
//  Rewards+Status.swift
//
//
//  Created by Victor Cantu on 2/23/24.
//


import Foundation
import TCFundamentals
import TCFireSignal
import TaecelAPICore

extension RewardsComponents {
    
    public static func status(
        transId: String,
        phase: TaecelAPICore.PurchaseRevisionPhase,
        callback: @escaping ( (_ resp: APIResponseGeneric<StatusResponseType>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "status",
            StatusRequest(
                transId: transId,
                phase: phase
            )
        ) { payload in
            guard let data = payload else{
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<StatusResponseType>.self, from: data)
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

