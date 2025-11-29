//
//  Theme+GetViewService.swift
//  
//
//  Created by Victor Cantu on 1/16/25.
//

import Foundation
import TCFundamentals
import TCFireSignal
import TaecelAPICore

extension ThemeComponents {
    
    public static func getViewService(
        id: UUID,
        callback: @escaping ( (_ resp: APIResponseGeneric<GetViewServiceResponse>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "getViewService",
            GetViewServiceRequest(
                id: id
            )
        ) { data in
            
            guard let data else{
                callback(nil)
                return
            }
            
            do{
                callback(try JSONDecoder().decode(APIResponseGeneric<GetViewServiceResponse>.self, from: data))
            }
            catch{
                print("⭕️ \(#file)")
                print(error)
                callback(nil)
            }
            
        }
    }
}
