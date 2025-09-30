//
//  Cust+GetJobPosts.swift
//  
//
//  Created by Victor Cantu on 6/21/24.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustAPIEndpointV1 {
    static func getJobPosts(
        callback: @escaping ((_ resp: APIResponseGeneric<[CustJobPostQuick]>?) -> ())
    ) {
        sendPost(
            rout,
            version,
            "getJobPosts",
            EmptyPayload()
        ) { data in
            guard let data else{
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<[CustJobPostQuick]>.self, from: data)
                callback(resp)
            }
            catch {
                callback(nil)
            }
        }
    }
}
