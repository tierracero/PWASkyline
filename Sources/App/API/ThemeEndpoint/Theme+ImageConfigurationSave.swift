//
//  Theme+ImageConfigurationSave.swift
//
//
//  Created by Victor Cantu on 1/20/25.
//

import Foundation
import TCFundamentals
import TCFireSignal
import TaecelAPICore

extension ThemeComponents {
    
    public static func imageConfigurationSave(
        mediaId: UUID,
        relationType: ImageConfigurationSaveType,
        configLanguage: LanguageCode,
        fileName: String,
        callback: @escaping ( (_ resp: APIResponse?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "imageConfigurationSave",
            ImageConfigurationSaveRequest(
                mediaId: mediaId,
                relationType: relationType,
                configLanguage: configLanguage,
                fileName: fileName
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
