//
//  Cust+AdvancesSearch.swift
//
//
//  Created by Victor Cantu on 10/10/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustComponents {
        
    static func advancesSearch(
        businessTerm: String,
        firstName: String,
        lastName: String,
        communication: String,
        street: String,
        colonie: String,
        city: String,
        tag1: String,
        tag2: String,
        tag3: String,
        tag4: String,
        description: String,
        startAt: Int64,
        endAt: Int64,
        callback: @escaping ( (_ resp: APIResponseGeneric<AdvancesSearchResponse>?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "advancesSearch",
            AdvancesSearchRequest(
                businessTerm: businessTerm,
                firstName: firstName,
                lastName: lastName,
                communication: communication,
                street: street,
                colonie: colonie,
                city: city,
                tag1: tag1,
                tag2: tag2,
                tag3: tag3,
                tag4: tag4,
                description: description,
                startAt: startAt,
                endAt: endAt
            )
        ) { data in
            
            guard let data else {
                callback(nil)
                return
            }
            
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<AdvancesSearchResponse>.self, from: data)
                callback(resp)
            }
            catch{
                print("🔴 API_DECODING_ERROR")
                print(error)
                callback(nil)
            }
        }
    }
}
