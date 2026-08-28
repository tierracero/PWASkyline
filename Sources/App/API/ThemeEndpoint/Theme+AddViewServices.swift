//
//  Theme+AddViewServices.swift
//
//
//  Created by Victor Cantu on 1/16/25.
//

import Foundation
import TCFundamentals
import TCFireSignal
import TaecelAPICore

extension ThemeComponents {
    
    public static func addViewServices(
        name: String,
        title_en: String,
        smallDescription: String,
        descr_sm_en: String,
        description: String,
        descr_en: String,
        cost: String,
        configLanguage: LanguageCode,
        inPromo: Bool,
        files: [FileObject],
        callback: @escaping ( (_ resp: APIResponseGeneric<AddViewServicesResponse>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "addViewServices",
            AddViewServicesRequest(
                name: name,
                title_en: title_en,
                smallDescription: smallDescription,
                descr_sm_en: descr_sm_en,
                description: description,
                descr_en: descr_en,
                cost: cost,
                configLanguage: configLanguage,
                inPromo: inPromo,
                files: files
            )
        ) { data in
            
            guard let data else{
                callback(nil)
                return
            }
            
            do{
                callback(try decodeAPIResponse(APIResponseGeneric<AddViewServicesResponse>.self, from: data))
            }
            catch{
                print("⭕️ \(#file)")
                print(error)
                callback(nil)
            }
            
        }
    }
}
