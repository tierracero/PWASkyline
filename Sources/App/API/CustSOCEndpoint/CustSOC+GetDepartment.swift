//
//  CustSOC+GetDepartment.swift
//  
//
//  Created by Victor Cantu on 3/31/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustSOCEndpointV1 {
    
    static func getDepartment(
        depid: UUID,
        callback: @escaping ( (_ resp: APIResponseGeneric<CustSvcDeps>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "getDepartment",
            GetDepartmentsRequest(
                depid: depid
            )
        ) { payload in
            guard let data = payload else{
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<CustSvcDeps>.self, from: data)
                callback(resp)
            }
            catch{
                print(error)
                callback(nil)
            }
        }
    }
}

