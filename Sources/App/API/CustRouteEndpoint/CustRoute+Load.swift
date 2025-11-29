//
//  CustRoute+Load.swift
//  
//
//  Created by Victor Cantu on 11/12/24.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustRouteComponents {
    
    static func load(
        routeId: UUID,
        callback: @escaping ( (_ resp: APIResponseGeneric<LoadResponse>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "load",
            LoadRequest(
                routeId: routeId
            )
        ) { data in
            guard let data else {
                callback(nil)
                return
            }
            do{
                callback(try JSONDecoder().decode(APIResponseGeneric<LoadResponse>.self, from: data))
            }
            catch{
                print(error)
                callback(nil)
            }
        }
    }
}
