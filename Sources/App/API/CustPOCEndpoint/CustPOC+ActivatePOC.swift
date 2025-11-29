//
//  CustPOC+ActivatePOC.swift
//
//
//  Created by Victor Cantu on 9/20/24.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustPOCComponents {
    
    static func activatePOC(
        pocId: UUID,
        callback: @escaping ( (_ resp: APIResponse?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "activatePOC",
            ActivatePOCRequest(
                pocId: pocId
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
                print(error)
                callback(nil)
            }
        }
    }
}
