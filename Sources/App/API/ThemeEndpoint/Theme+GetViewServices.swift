//
//  Theme+GetViewServices.swift
//
//
//  Created by Victor Cantu on 1/16/25.
//

import Foundation
import TCFundamentals
import TCFireSignal
import TaecelAPICore

extension ThemeEndpointV1 {
    
    public static func getViewServices(
        configLanguage: LanguageCode,
        callback: @escaping ( (_ resp: APIResponseGeneric<GetViewServicesResponse>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "getViewServices",
            GetViewServicesRequest(
                configLanguage: configLanguage
            )
        ) { data in
            
            guard let data else{
                callback(nil)
                return
            }
            
            do{
                callback(try JSONDecoder().decode(APIResponseGeneric<GetViewServicesResponse>.self, from: data))
            }
            catch{
                print("⭕️ \(#file)")
                print(error)
                callback(nil)
            }
            
        }
    }
}
