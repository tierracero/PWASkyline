//
//  Cust+RequestTask.swift
//  
//
//  Created by Victor Cantu on 10/23/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustAPIEndpointV1 {
        
    static func requestTask(
        type: CustTaskAuthorizationManagerAlertType,
        level: CustTaskAuthorizationManagerAlertLevel,
        relationId: UUID?,
        targetIds: [UUID],
        description: String,
        callback: @escaping ( (_ resp: APIResponseGeneric<RequestTaskResponse>?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "requestTask",
            RequestTaskRequest(
                type: type,
                level: level,
                relationId: relationId,
                targetIds: targetIds,
                description: description
            )
        ) { payload in
            
            guard let data = payload else {
                callback(nil)
                return
            }
            
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<RequestTaskResponse>.self, from: data)
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
