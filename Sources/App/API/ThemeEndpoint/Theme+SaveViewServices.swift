//
//  Theme+SaveViewServices.swift
//  
//
//  Created by Victor Cantu on 1/19/25.
//

import Foundation
import TCFundamentals
import TCFireSignal
import TaecelAPICore

extension ThemeEndpointV1 {
    
    public static func saveViewServices(
        id: UUID,
        name: String,
        smallDescription: String,
        description: String,
        cost: String,
        configLanguage: LanguageCode,
        inPromo: Bool,
        callback: @escaping ( (_ resp: APIResponse?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "saveViewServices",
            SaveViewServicesRequest(
                id: id,
                name: name,
                smallDescription: smallDescription,
                description: description,
                cost: cost,
                configLanguage: configLanguage,
                inPromo: inPromo
            )
        ) { data in
            
            guard let data else{
                callback(nil)
                return
            }
            
            do{
                callback(try JSONDecoder().decode(APIResponse.self, from: data))
            }
            catch{
                print("⭕️ \(#file)")
                print(error)
                callback(nil)
            }
            
        }
    }
}
