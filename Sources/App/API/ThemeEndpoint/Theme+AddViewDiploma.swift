//
//  Theme+AddViewDiploma.swift
//
//
//  Created by Victor Cantu on 1/16/25.
//

import Foundation
import TCFundamentals
import TCFireSignal
import TaecelAPICore

extension ThemeComponents {
    
    public static func addViewDiploma(
        name: String,
        smallDescription: String,
        description: String,
        configLanguage: LanguageCode,
        inPromo: Bool,
        files: [FileObject],
        callback: @escaping ( (_ resp: APIResponseGeneric<AddViewDiplomaResponse>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "addViewDiploma",
            AddViewDiplomaRequest(
                name: name,
                smallDescription: smallDescription,
                description: description,
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
                callback(try JSONDecoder().decode(APIResponseGeneric<AddViewDiplomaResponse>.self, from: data))
            }
            catch{
                print("⭕️ \(#file)")
                print(error)
                callback(nil)
            }
            
        }
    }
}
