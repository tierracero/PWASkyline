//
//  Theme+GetViewService.swift
//  
//
//  Created by Victor Cantu on 1/16/25.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension ThemeComponents {
    
    public static func getViewDiploma(
        id: UUID,
        callback: @escaping ( (_ resp: APIResponseGeneric<GetViewDiplomaResponse>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "getViewDiploma",
            GetViewDiplomaRequest(
                id: id
            )
        ) { data in
            
            guard let data else{
                callback(nil)
                return
            }
            
            do{
                callback(try JSONDecoder().decode(APIResponseGeneric<GetViewDiplomaResponse>.self, from: data))
            }
            catch{
                print("⭕️ \(#file)")
                print(error)
                callback(nil)
            }
            
        }
    }
}
