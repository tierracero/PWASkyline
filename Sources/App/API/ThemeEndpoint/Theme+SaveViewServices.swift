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

extension ThemeComponents {
    
    public static func saveViewServices(
        id: UUID,
        name: String,
        title_en: String,
        smallDescription: String,
        descr_sm_en: String,
        description: String,
        descr_en: String,
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
                title_en: title_en,
                smallDescription: smallDescription,
                descr_sm_en: descr_sm_en,
                description: description,
                descr_en: descr_en,
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
                callback(try decodeAPIResponse(APIResponse.self, from: data))
            }
            catch{
                print("⭕️ \(#file)")
                print(error)
                callback(nil)
            }
            
        }
    }
}
