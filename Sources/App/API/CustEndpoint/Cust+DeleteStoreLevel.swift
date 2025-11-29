//
//  Cust+DeleteStoreLevel.swift
//  
//
//  Created by Victor Cantu on 8/28/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustComponents {
        
    static func deleteStoreLevel(
        id: UUID,
        type: CustProductType,
        callback: @escaping ( (_ resp: APIResponse?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "deleteStoreLevel",
            DeleteStoreLevelRequest(
                id: id,
                type: type
            )
        ) { payload in
            
            guard let payload else{
                callback(nil)
                return
            }
            
            do{
                let resp = try JSONDecoder().decode(APIResponse?.self, from: payload)
                callback(resp)
            }
            catch {
                callback(nil)
            }
            
        }
    }
}
