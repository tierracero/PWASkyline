//
//  Cust+LowerNotePriority.swift
//
//
//  Created by Victor Cantu on 1/30/24.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustComponents {
    
    static func lowerNotePriority(
        noteId: LowerNotePriority,
        callback: @escaping ( 
            (_ resp: APIResponse?) -> ()
        )
    ) {
        
        sendPost(
            rout,
            version,
            "lowerNotePriority",
            LowerNotePriorityRequest(
                noteId:noteId
            )
        ) { data in
            
            guard let data else{
                callback(nil)
                return
            }
            
            do{
                let resp = try JSONDecoder().decode(APIResponse.self, from: data)
                callback(resp)
            }
            catch{
                print("🔴 API_DECODING_ERROR")
                print(error)
                callback(nil)
            }
        }
    }
}

