//
//  Cust+AddJobPost.swift
//
//
//  Created by Victor Cantu on 6/21/24.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustComponents {
    
    static func addJobPost(
        storeId: UUID,
        type: JobPostType,
        psychometricsLevel: PsychometricLevel,
        psychometricsTest: [UUID],
        primaryTasks: [UUID],
        secondaryTasks: [UUID],
        rules: [UUID],
        name: String,
        description: String,
        requirements: [JobPostRequierments],
        callback: @escaping ( (_ resp: APIResponseGeneric<CustJobPost>?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "addJobPost",
            AddJobPostRequest(
                storeId: storeId,
                type: type,
                psychometricsLevel: psychometricsLevel,
                psychometricsTest: psychometricsTest,
                primaryTasks: primaryTasks,
                secondaryTasks: secondaryTasks,
                rules: rules,
                name: name,
                description: description,
                requirements: requirements
            )
        ) { data in
            guard let data else{
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<CustJobPost>.self, from: data)
                callback(resp)
            }
            catch {
                callback(nil)
            }
        }
    }
}
