//
//  Cust+RemovePsychometricsTestAnswer.swift
//  
//
//  Created by Victor Cantu on 7/22/25.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustAPIEndpointV1 {
    
    static func removePsychometricsTestAnswer (
        answerId: UUID,
        callback: @escaping ( (_ resp: APIResponse?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "removePsychometricsTestAnswer",
            RemovePsychometricsTestAnswerRequest(
                answerId: answerId
            )
        ) { data in
            guard let data else {
                callback(nil)
                return
            }
            do{
                callback(try JSONDecoder().decode(APIResponse.self, from: data))
            }
            catch{
                print("🔴 API_DECODING_ERROR")
                print(error)
                callback(nil)
            }
        }
    }
}
