//
//  API+GetGEOCities.swift
//
//
//  Created by Victor Cantu on 10/24/24.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension APIEndpointV1 {

    static func getGEOCities(
        state: CountryStatesMexico,
        callback: @escaping ( (_ resp: APIResponseGeneric< [PostalCodesMexicoItem]>?) -> () )
    ) {
        
        if let payload = CatchControler.shared.cityRefrence[.mexico]?[state.rawValue] {
            
            callback(.init(
                status: .ok,
                data: payload
            ))
            
            return
        }
        
        sendPost(
            rout,
            version,
            "getGEOCities",
            GetGEOCitiesRequest(
                state: state
            )
        ) { data in
            
            guard let data else{
                callback(nil)
                return
            }
            
            do{
                
                let payload = try JSONDecoder().decode(APIResponseGeneric< [PostalCodesMexicoItem]>.self, from: data)
                
                guard let data = payload.data else {
                    callback(nil)
                    return
                }

                if !data.isEmpty {
                    CatchControler.shared.setCityRefrence(
                        country: .mexico,
                        state: state.rawValue,
                        cities: data
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

