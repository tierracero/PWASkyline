//
//  Cust+AddPsychometricsTestAnswer.swift
//  
//
//  Created by Victor Cantu on 7/22/25.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustComponents {
    
    static func addPsychometricsTestAnswer (
        questionId: UUID,
        type: PsychometricsTestAnswersType,
        answer: String,
        callback: @escaping ( (_ resp: APIResponseGeneric<PsychometricsTestAnswersQuick>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "addPsychometricsTestAnswer",
            AddPsychometricsTestAnswerRequest(
                questionId: questionId,
                type: type,
                answer: answer
            )
        ) { data in
            guard let data else {
                callback(nil)
                return
            }
            do{
                callback(try JSONDecoder().decode(APIResponseGeneric<PsychometricsTestAnswersQuick>.self, from: data))
            }
            catch{
                print("🔴 API_DECODING_ERROR")
                print(error)
                callback(nil)
            }
        }
    }
}
