//
//  Cust+SaveJobTask.swift
//  
//
//  Created by Victor Cantu on 6/21/24.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustComponents {
    static func saveJobTask(
        taskId: UUID,
        storeId: UUID,
        jobId: UUID,
        type: JobTaskType,
        executeAt: [Int],
        subExecuteAt: Int?,
        name: String,
        reason: String,
        description: String,
        callback: @escaping ( (_ resp: APIResponse?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "saveJobTask",
            SaveJobTaskRequest(
                taskId: taskId,
                storeId: storeId,
                jobId: jobId,
                type: type,
                executeAt: executeAt,
                subExecuteAt: subExecuteAt,
                name: name,
                reason: reason,
                description: description
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
