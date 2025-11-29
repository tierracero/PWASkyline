//
//  Fiscal+GetFiscalOperators.swift
//  
//
//  Created by Victor Cantu on 2/25/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension FiscalComponents {
    
    static func getFiscalOperators(
        callback: @escaping ( (_ resp: APIResponseGeneric<[CustFiscalOperator]>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "getFiscalOperators",
            EmptyPayload()
        ) { payload in
            guard let data = payload else{
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<[CustFiscalOperator]>.self, from: data)
                callback(resp)
            }
            catch{
                print(error)
                callback(nil)
            }
        }
        
    }
}
