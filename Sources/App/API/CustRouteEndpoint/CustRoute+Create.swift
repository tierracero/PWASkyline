//
//  CustRoute+Create.swift
//
//
//  Created by Victor Cantu on 11/5/24.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustRouteEndpointV1 {
    
    static func create(
        storeId: UUID,
        supervisor: UUID,
        assignUsers: [UUID],
        name: String,
        day: Int,
        month: Int,
        year: Int,
        initialTime: String,
        endingTime: String,
        items: [OrderRouteItem],
        travel: Int64,
        distance: Int64,
        callback: @escaping ( (_ resp: APIResponseGeneric<CreateResponse>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "create",
            CreateRequest(
                storeId: storeId,
                supervisor: supervisor,
                assignUsers: assignUsers,
                name: name,
                day: day,
                month: month,
                year: year,
                initialTime: initialTime,
                endingTime: endingTime,
                items: items,
                travel: travel,
                distance: distance
            )
        ) { data in
            guard let data else {
                callback(nil)
                return
            }
            do{
                callback(try JSONDecoder().decode(APIResponseGeneric<CreateResponse>.self, from: data))
            }
            catch{
                print(error)
                callback(nil)
            }
        }
    }
}
