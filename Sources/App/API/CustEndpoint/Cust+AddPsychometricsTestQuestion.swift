//
//  Cust+AddPsychometricsTestQuestion.swift
//  
//
//  Created by Victor Cantu on 7/22/25.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustAPIEndpointV1 {
    
    static func addPsychometricsTestQuestion (
        testid: UUID,
        question: String,
        answers: [CreatePsychometricsTestAnswers],
        callback: @escaping ( (_ resp: APIResponseGeneric<AddPsychometricsTestQuestionResponse>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "addPsychometricsTestQuestion",
            AddPsychometricsTestQuestionRequest(
                testid: testid,
                question: question,
                answers: answers
            )
        ) { data in
            guard let data else {
                callback(nil)
                return
            }
            do{
                callback(try JSONDecoder().decode(APIResponseGeneric<AddPsychometricsTestQuestionResponse>.self, from: data))
            }
            catch{
                print("🔴 API_DECODING_ERROR")
                print(error)
                callback(nil)
            }
        }
    }
}
