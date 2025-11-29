//
//  Fiscal+GetFiscaXMLIngreso.swift
//  
//
//  Created by Victor Cantu on 9/14/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension FiscalComponents {
    
    static func getFiscaXMLIngreso(
        id: UUID,
        callback: @escaping ( (_ resp: APIResponseGeneric<FiscalXMLIngresoResponse>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "getFiscaXMLIngreso",
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
                let resp = try JSONDecoder().decode(APIResponseGeneric<FiscalXMLIngresoResponse>.self, from: data)
                callback(resp)
            }
            catch{
                print(error)
                callback(nil)
            }
        }
        
    }
}

