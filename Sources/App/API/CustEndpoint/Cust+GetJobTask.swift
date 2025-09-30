//
//  Cust+GetJobTask.swift
//  
//
//  Created by Victor Cantu on 6/21/24.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustAPIEndpointV1 {
    static func getJobTask(
        taskId: UUID,
        callback: @escaping ( (_ resp: APIResponseGeneric<CustJobTask>?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "getJobTask",
            GetJobTaskRequest(
                taskId: taskId
            )
        ) { data in
            guard let data else{
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<CustJobTask>.self, from: data)
                callback(resp)
            }
            catch {
                callback(nil)
            }
        }
    }
}
