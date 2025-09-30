//
//  Fiscal+GetCurrentCancelations.swift
//  
//
//  Created by Victor Cantu on 6/16/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension FiscalEndpointV1 {
    
    static func getCurrentCancelations(
        callback: @escaping ( (_ resp: APIResponseGeneric<[CustFiscalCancelationManager]>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "getCurrentCancelations",
            EmptyPayload()
        ) { payload in
            
            guard let payload else{
                callback(nil)
                return
            }
            
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<[CustFiscalCancelationManager]>.self, from: payload)
                callback(resp)
            }
            catch{
                print(error)
                callback(nil)
            }
        }
    }
}
