//
//  Cust+SavePsychometricsTestQuestion.swift
//  
//
//  Created by Victor Cantu on 7/22/25.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustComponents {
    
    static func savePsychometricsTestQuestion (
        questionId: UUID,
        question: String,
        callback: @escaping ( (_ resp: APIResponse?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "savePsychometricsTestQuestion",
            SavePsychometricsTestQuestionRequest(
                questionId: questionId,
                question: question
            )
        ) { data in
            guard let data else {
                callback(nil)
                return
            }
            do{
                callback( try JSONDecoder().decode(APIResponse.self, from: data))
            }
            catch{
                print("🔴 API_DECODING_ERROR")
                print(error)
                callback(nil)
            }
        }
    }
}
