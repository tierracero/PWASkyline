//
//  CustSOC+RemoveRelatedCode.swift
//  
//
//  Created by Victor Cantu on 10/31/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustSOCComponents {
    
    static func removeRelatedCode(
        currentId: UUID,
        targetId: UUID,
        callback: @escaping ( (_ resp: APIResponse?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "removeRelatedCode",
            RemoveRelatedCodeRequest(
                currentId: currentId,
                targetId: targetId
            )
        ) { payload in
            guard let data = payload else{
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponse.self, from: data)
                callback(resp)
            }
            catch{
                print(error)
                callback(nil)
            }
        }
    }
}
