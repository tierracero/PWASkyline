//
//  CustSOC+GetDepartments.swift
//  
//
//  Created by Victor Cantu on 3/31/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustSOCComponents {
    
    static func getDepartments(
        callback: @escaping ( (_ resp: APIResponseGeneric<[CustSvcDepsQuick]>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "getDepartments",
            EmptyPayload()
        ) { payload in
            guard let data = payload else{
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<[CustSvcDepsQuick]>.self, from: data)
                callback(resp)
            }
            catch{
                print(error)
                callback(nil)
            }
        }
    }
}
