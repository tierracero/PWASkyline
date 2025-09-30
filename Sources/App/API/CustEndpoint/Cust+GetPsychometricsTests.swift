//
//  Cust+GetPsychometricsTests.swift
//  
//
//  Created by Victor Cantu on 6/21/24.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustAPIEndpointV1 {
    static func getPsychometricsTests(
        type: GetPsychometricsTestsType,
        callback: @escaping ( (_ resp: APIResponseGeneric<[PsychometricsTestQuick]>?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "getPsychometricsTests",
            GetPsychometricsTestsRequest(
                  type: type
            )
        ) { data in
            guard let data else {
                callback(nil)
                return
            }
            do{
                callback(try JSONDecoder().decode(APIResponseGeneric<[PsychometricsTestQuick]>.self, from: data))
            }
            catch {
                callback(nil)
            }
        }
    }
}
