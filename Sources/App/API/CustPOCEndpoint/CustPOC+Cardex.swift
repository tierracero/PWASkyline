//
//  CustPOC+Cardex.swift
//
//
//  Created by Victor Cantu on 9/26/24.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustPOCComponents {
    
    static func cardex(
        relationId: UUID,
        pocIds: [UUID],
        startAt: Int64,
        endAt: Int64,
        callback: @escaping ( (_ resp: APIResponseGeneric<CardexResponse>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "cardex",
            CardexRequest(
                relationId: relationId,
                pocIds: pocIds,
                startAt: startAt,
                endAt: endAt
            )
        ) { data in
            guard let data else{
                callback(nil)
                return
            }
            do{
                callback(try JSONDecoder().decode(APIResponseGeneric<CardexResponse>.self, from: data))
            }
            catch{
                print(error)
                callback(nil)
            }
        }
    }
}

