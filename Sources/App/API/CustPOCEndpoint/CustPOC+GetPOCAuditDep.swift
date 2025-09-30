//
//  CustPOC+GetPOCAuditDep.swift
//  
//
//  Created by Victor Cantu on 8/28/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustPOCEndpointV1 {
    
    static func getPOCAuditDep(
        storeid: UUID,
        depid: UUID,
        callback: @escaping ( (_ resp: APIResponseGeneric<GetPOCAuditDepResponse>?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "getPOCAuditDep",
            GetPOCAuditDepRequest(
                storeid: storeid,
                depid: depid
            )
        ) { payload in
            guard let data = payload else{
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<GetPOCAuditDepResponse>.self, from: data)
                callback(resp)
            }
            catch{
                print(error)
                callback(nil)
            }
        }
    }
}

