//
//  CustPOC+GetPOCAudit.swift
//  
//
//  Created by Victor Cantu on 8/28/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustPOCComponents {
    
    static func getPOCAudit(
        storeid: UUID,
        callback: @escaping ( (_ resp: APIResponseGeneric<GetPOCAuditResponse>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "getPOCAudit",
            GetPOCAuditRequest(
                storeid: storeid
            )
        ) { payload in
            guard let data = payload else{
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<GetPOCAuditResponse>.self, from: data)
                callback(resp)
            }
            catch{
                print(error)
                callback(nil)
            }
        }
    }
}

