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
        smallDescription: String,
        description: String,
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
                smallDescription: smallDescription,
                description: description,
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
                callback(try JSONDecoder().decode(APIResponseGeneric<AddViewServicesResponse>.self, from: data))
            }
            catch{
                print("⭕️ \(#file)")
                print(error)
                callback(nil)
            }
            
        }
    }
}
