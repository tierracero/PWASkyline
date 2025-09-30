//
//  Fiscal+SaveFiscalOperators.swift
//
//
//  Created by Victor Cantu on 3/14/25.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension FiscalEndpointV1 {
    
    static func saveFiscalOperators(
        id: UUID,
        name: String,
        licence: String,
        rfc: String,
        expire: Int64?,
        callback: @escaping ( (_ resp: APIResponse?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "saveFiscalOperators",
            SaveFiscalOperatorsRequest(
                id: id,
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
                callback(try JSONDecoder().decode(APIResponse.self, from: data))
            }
            catch{
                print(error)
                callback(nil)
            }
            
        }
    }
}
