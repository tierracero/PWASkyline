//
//  CustRoute+UserLocations.swift
//  
//
//  Created by Victor Cantu on 12/21/24.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustRouteEndpointV1 {
    
    static func userLocations(
        callback: @escaping ( (_ resp: APIResponseGeneric<UserLocationsResponse>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "userLocations",
            EmptyPayload()
        ) { data in
            guard let data else {
                callback(nil)
                return
            }
            do{
                callback(try JSONDecoder().decode(APIResponseGeneric<UserLocationsResponse>.self, from: data))
            }
            catch{
                print(error)
                callback(nil)
            }
        }
    }
}
