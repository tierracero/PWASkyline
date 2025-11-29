//
//  Cust+DeleteJobPost.swift
//  
//
//  Created by Victor Cantu on 6/21/24.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustComponents {
    static func deleteJobPost(
        jobId: UUID,
        taskDisposition: [DeleteJobPostTaskDispatch],
        callback: @escaping ( (_ resp: APIResponse?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "deleteJobPost",
            DeleteJobPostRequest(
                jobId: jobId,
                taskDisposition: taskDisposition
            )
        ) { data in
            guard let data else{
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponse.self, from: data)
                callback(resp)
            }
            catch {
                callback(nil)
            }
        }
    }
}
