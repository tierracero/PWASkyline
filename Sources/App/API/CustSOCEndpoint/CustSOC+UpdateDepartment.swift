//
//  CustSOC+UpdateDepartment.swift
//  
//
//  Created by Victor Cantu on 3/31/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustSOCEndpointV1 {
    
    static func updateDepartment(
        depid: UUID,
        name: String,
        smallDescription: String,
        description: String,
        icon: String,
        coverLandscape: String,
        coverPortrait: String,
        callback: @escaping ( (_ resp: APIResponse?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "updateDepartment",
            UpdateDepartmentRequest(
                depid: depid,
                name: name,
                smallDescription: smallDescription,
                description: description,
                icon: icon,
                coverLandscape: coverLandscape,
                coverPortrait: coverPortrait
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
                print(error)
                callback(nil)
            }
        }
    }
}

