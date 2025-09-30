//
//  Cust+ChangeCustJobPostAvailability.swift
//
//
//  Created by Victor Cantu on 6/21/24.
//

import Foundation
import TCFundamentals
import TCFireSignal



extension CustAPIEndpointV1 {
    static func changeCustJobPostAvailability(
        jobId: UUID,
        state: Bool,
        callback: @escaping ( (_ resp: APIResponseGeneric<String>?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "changeCustJobPostAvailability",
            ChangeCustJobPostAvailabilityRequest(
                jobId: jobId,
                state: state
            )
        ) { data in
            guard let data else{
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<String>.self, from: data)
                callback(resp)
            }
            catch {
                callback(nil)
            }
        }
    }
}
