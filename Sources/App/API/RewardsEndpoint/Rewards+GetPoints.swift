//
//  Rewards+GetPoints.swift
//
//
//  Created by Victor Cantu on 2/17/24.
//

import Foundation
import TCFundamentals
import TCFireSignal
import SiweAPICore

extension RewardsComponents {
    
    public static func getPoints(
        cardId: String,
        callback: @escaping ( (_ resp: APIResponseGeneric<RewardPoints>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "getPoints",
            GetPointsRequest(
                cardId: cardId
            )
        ) { payload in
            guard let data = payload else{
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<RewardPoints>.self, from: data)
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
