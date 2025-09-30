//
//  Cust+WorkWithUsSaveTest.swift
//  
//
//  Created by Victor Cantu on 6/5/23.
//

/*

import Foundation
import TCFundamentals
import TCFireSignal

extension CustAPIEndpointV1 {
        
    public static func workWithUsSaveTest(
        evaluation: EvaluationQuick,
        evaluationsAnswers: [EvaluationAnswersQuick],
        profileid: UUID,
        subProfileid: UUID,
        callback: @escaping ( (_ resp: APIResponse?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "workWithUsSaveTest",
            WorkWithUsSaveTestRequest(
                evaluation: evaluation,
                evaluationsAnswers: evaluationsAnswers,
                profileid: profileid,
                subProfileid: subProfileid
            )
        ) { payload in
            
            guard let data = payload else{
                callback(nil)
                return
            }
            
            do{
                let resp = try JSONDecoder().decode(APIResponse.self, from: data)
                callback(resp)
            }
            catch{
                print("🔴 API_DECODING_ERROR")
                print(error)
                callback(nil)
            }
        }
    }
}
*/
