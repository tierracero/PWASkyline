//
//  Theme+OpenThemeSettings.swift
//
//
//  Created by Victor Cantu on 1/15/25.
//

import Foundation
import TCFundamentals
import TCFireSignal
import TaecelAPICore

extension ThemeEndpointV1 {
    
    public static func openThemeSettings(
        id: UUID,
        callback: @escaping ( (_ resp: APIResponseGeneric<CreationTempleteResponse>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "openThemeSettings",
            OpenThemeSettingsRequest(
                id: id
            )
        ) { data in
            
            guard let data else{
                callback(nil)
                return
            }
            
            do{
                callback(try JSONDecoder().decode(APIResponseGeneric<CreationTempleteResponse>.self, from: data))
            }
            catch{
                print("⭕️ \(#file)")
                print(error)
                callback(nil)
            }
            
        }
    }
}
