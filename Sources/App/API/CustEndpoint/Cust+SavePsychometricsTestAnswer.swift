//
//  Cust+SavePsychometricsTestAnswer.swift
//  
//
//  Created by Victor Cantu on 7/22/25.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustComponents {
    
    static func savePsychometricsTestAnswer (
        answerId: UUID,
        type: PsychometricsTestAnswersType,
        answer: String,
        callback: @escaping ( (_ resp: APIResponse?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "savePsychometricsTestAnswer",
            SavePsychometricsTestAnswerRequest(
                answerId: answerId,
                type: type,
                answer: answer
            )
        ) { data in
            guard let data  else {
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
