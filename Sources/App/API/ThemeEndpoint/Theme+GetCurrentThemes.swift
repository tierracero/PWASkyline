//
//  Theme+GetCurrentThemes.swift
//
//
//  Created by Victor Cantu on 1/10/25.
//

import Foundation
import TCFundamentals
import TCFireSignal
import TaecelAPICore

extension ThemeComponents {
    
    public static func getCurrentThemes(
        id: UUID,
        version themeVersion: Float,
        themName: String,
        themDescription: String,
        callback: @escaping ( (_ resp: APIResponseGeneric<[CurrentThemesObject]>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "getCurrentThemes",
            CurrentThemesObject(
                id: id,
                version: themeVersion,
                themeName: themName,
                themeDescription: themDescription
            )
        ) { data in
            
            guard let data else{
                callback(nil)
                return
            }
            
            do{
                callback(try JSONDecoder().decode(APIResponseGeneric<[CurrentThemesObject]>.self, from: data))
            }
            catch{
                print("⭕️ \(#file)")
                print(error)
                callback(nil)
            }
            
        }
    }
}
