//
//  CustPOC+PausePOC.swift
//  
//
//  Created by Victor Cantu on 6/17/24.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustPOCEndpointV1 {
    
    static func pausePOC(
        pocId: UUID,
        callback: @escaping ( (_ resp: APIResponse?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "pausePOC",
            PausePOCRequest(
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
