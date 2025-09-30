//
//  Cust+GetJobPost.swift
//
//
//  Created by Victor Cantu on 6/21/24.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustAPIEndpointV1 {
    static func getJobPost(
        jobId: UUID,
        callback: @escaping ( (_ resp: APIResponseGeneric<GetJobPostResponse>?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "getJobPost",
            GetJobPostRequest(
                jobId: jobId
            )
        ) { data in
            guard let data else{
                callback(nil)
                return
            }
            
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<GetJobPostResponse>.self, from: data)
                callback(resp)
            }
            catch {
                callback(nil)
            }
        }
    }
}
