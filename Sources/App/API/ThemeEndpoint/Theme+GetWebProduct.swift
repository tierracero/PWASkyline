//
//  Theme+GetWebProduct.swift
//  
//
//  Created by Victor Cantu on 1/16/25.
//

import Foundation
import TCFundamentals
import TCFireSignal
import TaecelAPICore

extension ThemeComponents {
    
    public static func getWebProduct(
        theme: String,
        configLanguage: LanguageCode,
        callback: @escaping ( (_ resp: APIResponseGeneric<GetWebProductResponse>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "getWebProduct",
            GetWebDataRequest(
                theme: theme,
                configLanguage: configLanguage
            )
        ) { data in
            
            guard let data else{
                callback(nil)
                return
            }
            
            do{
                callback(try JSONDecoder().decode(APIResponseGeneric<GetWebProductResponse>.self, from: data))
            }
            catch{
                print("⭕️ \(#file)")
                print(error)
                callback(nil)
            }
            
        }
    }
}
