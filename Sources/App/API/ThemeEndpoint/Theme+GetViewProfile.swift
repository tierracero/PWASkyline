//
//  Theme+GetViewProfile.swift
//  
//
//  Created by Victor Cantu on 1/16/25.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension ThemeComponents {
    
    public static func getViewProfile(
        id: UUID,
        callback: @escaping ( (_ resp: APIResponseGeneric<GetViewProfileResponse>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "getViewProfile",
            GetViewProfileRequest(
                id: id
            )
        ) { data in
            
            guard let data else{
                callback(nil)
                return
            }
            
            do{
                callback(try JSONDecoder().decode(APIResponseGeneric<GetViewProfileResponse>.self, from: data))
            }
            catch{
                print("⭕️ \(#file)")
                print(error)
                callback(nil)
            }
            
        }
    }
}
