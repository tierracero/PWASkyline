//
//  Theme+GetLogos.swift
//
//
//  Created by Victor Cantu on 1/10/25.
//

import Foundation
import TCFundamentals
import TCFireSignal
import TaecelAPICore

extension ThemeComponents {
    
    public static func getLogos(
        callback: @escaping ( (_ resp: APIResponseGeneric<GetLogosResponse>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "getLogos",
            EmptyPayload()
        ) { data in
            
            guard let data else{
                callback(nil)
                return
            }
            
            do{
                callback(try JSONDecoder().decode(APIResponseGeneric<GetLogosResponse>.self, from: data))
            }
            catch{
                print("⭕️ \(#file)")
                print(error)
                callback(nil)
            }
            
        }
    }
}
