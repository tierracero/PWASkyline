//
//  Cust+CreatePsychometricsTest.swift
//  
//
//  Created by Victor Cantu on 7/14/25.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustComponents {
    
    static func createPsychometricsTest(
        tcaccount: UUID?,
        type: PsychometricType,
        level: PsychometricLevel,
        name: String,
        description: String,
        instruction: String,
        content: String?,
        jobrolid: UUID?,
        questions: [CreatePsychometricsTestQuestions],
        callback: @escaping ( (_ resp: APIResponseGeneric<CreatePsychometricsTestResponse>?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "createPsychometricsTest",
            CreatePsychometricsTestRequest(
                tcaccount: tcaccount,
                type: type,
                level: level,
                name: name,
                description: description,
                instruction: instruction,
                content: content,
                jobrolid: jobrolid,
                questions: questions
            )
        ) { data in
            guard let data else {
                callback(nil)
                return
            }
            do {
                callback(try JSONDecoder().decode(APIResponseGeneric<CreatePsychometricsTestResponse>.self, from: data))
            }
            catch{
                print("🔴 API_DECODING_ERROR")
                print(error)
                callback(nil)
            }
        }
    }
}

