//
//  Cust+GetJobTasks.swift
//  
//
//  Created by Victor Cantu on 6/21/24.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustComponents {
    static func getJobTasks(
        jobId: UUID?,
        callback: @escaping ( (_ resp: APIResponseGeneric<GetJobTasksResponse>?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "getJobTasks",
            GetJobTasksRequest(
                jobId: jobId
            )
        ) { data in
            guard let data else{
                callback(nil)
                return
            }
            do{
                let resp = try decodeAPIResponse(APIResponseGeneric<GetJobTasksResponse>.self, from: data)
                callback(resp)
            }
            catch {
                callback(nil)
            }
        }
    }
}
