//
//  Cust+AddJobTask.swift
//  
//
//  Created by Victor Cantu on 6/21/24.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustComponents {
    static func addJobTask(
        storeId: UUID,
        jobId: UUID,
        isPrimaryTask: Bool,
        type: JobTaskType,
        executeAt: [Int],
        subExecuteAt: Int?,
        name: String,
        reason: String,
        description: String,
        callback: @escaping ( (_ resp: APIResponseGeneric<CustJobTask>?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "addJobTask",
            AddJobTaskRequest(
                storeId: storeId,
                jobId: jobId,
                isPrimaryTask: isPrimaryTask,
                type: type,
                executeAt: executeAt,
                subExecuteAt: subExecuteAt,
                name: name,
                reason: reason,
                description: reason
            )
        ) { data in
            guard let data else {
                callback(nil)
                return
            }
            do{
                callback(try JSONDecoder().decode(APIResponseGeneric<CustJobTask>.self, from: data))
            }
            catch {
                print("🔴 DECODING ERROR \(#function)")
                print(error)
                callback(nil)
            }
        }
    }
}
