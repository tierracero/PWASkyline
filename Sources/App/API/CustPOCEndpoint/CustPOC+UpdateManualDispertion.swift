//
//  CustPOC+UpdateManualDispertion.swift
//  
//
//  Created by Victor Cantu on 12/14/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustPOCEndpointV1 {
    
    static func updateManualDispertion(
        docId: UUID,
        type: UpdateManualDispertionType,
        comment: String?,
        callback: @escaping ( (_ resp: APIResponse?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "updateManualDispertion",
            UpdateManualDispertionRequest(
                docId: docId,
                type: type,
                comment: comment
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
