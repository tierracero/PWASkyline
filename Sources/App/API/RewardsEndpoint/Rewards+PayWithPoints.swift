//
//  Rewards+PayWithPoints.swift
//
//
//  Created by Victor Cantu on 6/1/24.
//

import Foundation
import TCFundamentals
import TCFireSignal
import TaecelAPICore

extension RewardsComponents {
    
    public static func payWithPoints(
        cardId: String,
        points: Int,
        relationType: PayWithPointsType,
        relationId: UUID,
        callback: @escaping ( (_ resp: APIResponseGeneric<PayWithPointsResponse>?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "payWithPoints",
            PayWithPointsRequest(
                cardId: cardId,
                points: points,
                relationType: relationType,
                relationId: relationId
            )
        ) { data in
            guard let data else{
                callback(nil)
                return
            }
            do{
                callback(try JSONDecoder().decode(APIResponseGeneric<PayWithPointsResponse>.self, from: data))
            }
            catch{
                print("⭕️  \(#file)  \(#function)")
                print(error)
                callback(nil)
            }
        }
    }
    
}
