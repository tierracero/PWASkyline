//
//  Cust+SaveJobPost.swift
//  
//
//  Created by Victor Cantu on 6/21/24.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustAPIEndpointV1 {
    static func saveJobPost(
        storeId: UUID,
        jobId: UUID,
        type: JobPostType,
        psychometricsLevel: PsychometricLevel,
        psychometricsTest: [UUID],
        primaryTasks: [UUID],
        secondaryTasks: [UUID],
        name: String,
        description: String,
        requirements: [JobPostRequierments],
        callback: @escaping ( (_ resp: APIResponseGeneric<String>?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "saveJobPost",
            SaveJobPostRequest(
                storeId: storeId,
                jobId: jobId,
                type: type,
                psychometricsLevel: psychometricsLevel,
                psychometricsTest: psychometricsTest,
                primaryTasks: primaryTasks,
                secondaryTasks: secondaryTasks,
                name: name,
                description: description,
                requirements: requirements
            )
        ) { data in
            guard let data else {
                callback(nil)
                return
            }
            do{
                callback(try JSONDecoder().decode(APIResponseGeneric<String>.self, from: data))
            }
            catch {
                callback(nil)
            }
        }
    }
}
