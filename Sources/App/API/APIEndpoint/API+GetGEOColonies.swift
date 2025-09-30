//
//  API+GetGEOColonies.swift
//
//
//  Created by Victor Cantu on 10/24/24.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension APIEndpointV1 {

    static func getGEOColonies(
        state: CountryStatesMexico,
        city: String,
        callback: @escaping ( (_ resp: APIResponseGeneric<[PostalCodesMexicoItem]>?) -> () )
    ) {
        
        
        if let payload = CatchControler.shared.settelmentRefrence[.mexico]?[state.rawValue]?[city] {
            
            callback(.init(
                status: .ok,
                data: payload
            ))
            
            return
        }
        
        
        sendPost(
            rout,
            version,
            "getGEOColonies",
            GetGEOColoniesRequest(
                state: state,
                city: city
            )
        ) { data in
            
            guard let data else{
                callback(nil)
                return
            }
            do{
                
                let payload = try JSONDecoder().decode(APIResponseGeneric<[PostalCodesMexicoItem]>.self, from: data)
                
                guard let data = payload.data else {
                    callback(nil)
                    return
                }
                
                if !data.isEmpty {
                    CatchControler.shared.setSettelmentRefrence(
                        country: .mexico,
                        state: state.rawValue,
                        city: city,
                        settlements: data
                    )
                }
                
                
                callback(payload)
            }
            catch{
                print("🔴 API_DECODING_ERROR")
                print(error)
                callback(nil)
            }
        }
    }
}

