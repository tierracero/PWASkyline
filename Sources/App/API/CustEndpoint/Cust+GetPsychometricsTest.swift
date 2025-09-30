//
//  Cust+GetPsychometricsTest.swift
//  
//
//  Created by Victor Cantu on 6/21/24.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustAPIEndpointV1 {
    static func getPsychometricsTest(
        testId: UUID,
        callback: @escaping ( (_ resp: APIResponseGeneric<GetPsychometricsTestReponse>?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "getPsychometricsTest",
            GetPsychometricsTestRequest(
                testId: testId
            )
        ) { data in
            guard let data else {
                callback(nil)
                return
            }
            do {
                callback(try JSONDecoder().decode(APIResponseGeneric<GetPsychometricsTestReponse>.self, from: data))
            }
            catch {
                callback(nil)
            }
        }
    }
}
