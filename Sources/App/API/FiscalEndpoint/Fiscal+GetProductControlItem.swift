//
//  Fiscal+GetProductControlItem.swift
//  
//
//  Created by Victor Cantu on 2/11/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension FiscalComponents {
    
    static func getProductControlItem(
        pseudo: String,
        rfc: String,
        callback: @escaping ( (_ resp: APIResponseGeneric<CustFiscalProductControlQuick>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "getProductControlItem",
            GetProductControlItemRequest(
                pseudo: pseudo,
                rfc: rfc

            )
        ) { payload in
            guard let data = payload else{
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<CustFiscalProductControlQuick>.self, from: data)
                callback(resp)
            }
            catch{
                print(error)
                callback(nil)
            }
        }
        
    }
}

