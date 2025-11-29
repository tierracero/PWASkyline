//
//  Theme+SaveViewDiploma.swift
//  
//
//  Created by Victor Cantu on 1/19/25.
//

import Foundation
import TCFundamentals
import TCFireSignal
import TaecelAPICore

extension ThemeComponents {
    
    public static func saveViewDiploma(
        id: UUID,
        name: String,
        smallDescription: String,
        description: String,
        configLanguage: LanguageCode,
        inPromo: Bool,
        callback: @escaping ( (_ resp: APIResponse?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "saveViewDiploma",
            SaveViewDiplomaRequest(
                id: id,
                name: name,
                smallDescription: smallDescription,
                description: description,
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
