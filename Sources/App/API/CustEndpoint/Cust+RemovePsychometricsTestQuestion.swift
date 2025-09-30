//
//  Cust+RemovePsychometricsTestQuestion.swift
//  
//
//  Created by Victor Cantu on 7/22/25.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustAPIEndpointV1 {
    
    static func removePsychometricsTestQuestion (
        questionId: UUID,
        callback: @escaping ( (_ resp: APIResponse?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "removePsychometricsTestQuestion",
            RemovePsychometricsTestQuestionRequest(
                questionId: questionId
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
