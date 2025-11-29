//
//  Cust+SavePsychometricsTest.swift
//  
//
//  Created by Victor Cantu on 7/22/25.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustComponents {
    
    static func savePsychometricsTest (
        id: UUID,
        type: PsychometricType,
        level: PsychometricLevel,
        name: String,
        description: String,
        instruction: String,
        content: String?,
        jobrolid: UUID?,
        callback: @escaping ( (_ resp: APIResponse?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "savePsychometricsTest",
            SavePsychometricsTestRequest(
                id: id,
                type: type,
                level: level,
                name: name,
                description: description,
                instruction: instruction,
                content: content,
                jobrolid: jobrolid
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
