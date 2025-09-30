//
//  Cust+LinkJobTask.swift
//  
//
//  Created by Victor Cantu on 6/21/24.
// 

import Foundation
import TCFundamentals
import TCFireSignal

extension CustAPIEndpointV1 {
    static func linkJobTask(
        jobId: UUID,
        taskId: UUID,
        callback: @escaping ( (_ resp: APIResponse?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "linkJobTask",
            LinkJobTaskRequest(
                jobId: jobId,
                taskId: taskId
            )
        ) { data in
            guard let data else{
                callback(nil)
                return
            }
            do{
                callback(try JSONDecoder().decode(APIResponse.self, from: data))
            }
            catch {
                callback(nil)
            }
        }
    }
}
