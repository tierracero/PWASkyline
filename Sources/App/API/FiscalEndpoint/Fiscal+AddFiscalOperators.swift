//
//  Fiscal+AddFiscalOperators.swift
//
//
//  Created by Victor Cantu on 3/14/25.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension FiscalEndpointV1 {
    
    static func addFiscalOperators(
        name: String,
        rfc: String,
        licence: String,
        expire: Int64?,
        callback: @escaping ( (_ resp: APIResponseGeneric<CustFiscalOperator>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "addFiscalOperators",
            AddFiscalOperatorsRequest(
                name: name,
                licence: licence, 
                rfc: rfc, 
                expire: expire
            )
        ) { data in
            
            guard let data else{
                callback(nil)
                return
            }
            
            do{
                callback(try JSONDecoder().decode(APIResponseGeneric<CustFiscalOperator>.self, from: data))
            }
            catch{
                print(error)
                callback(nil)
            }
            
        }
    }
}
