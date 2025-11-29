//
//  Cust+StoreLoadDepartment.swift
//  
//
//  Created by Victor Cantu on 1/28/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustComponents {
        
    static func storeLoadDepartment(
        id: UUID,
        callback: @escaping ( (_ resp: APIResponseGeneric<StoreLoadDepartmentResponse>?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "storeLoadDepartment",
            APIRequestID(
                id: id,
                store: nil
            )
        ) { payload in
            
            guard let data = payload else{
                callback(nil)
                return
            }
            
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<StoreLoadDepartmentResponse>.self, from: data)
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
