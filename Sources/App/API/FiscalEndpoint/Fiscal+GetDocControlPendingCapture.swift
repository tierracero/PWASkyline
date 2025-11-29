//
//  Fiscal+GetDocControlPendingCapture.swift
//  
//
//  Created by Victor Cantu on 9/13/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension FiscalComponents {
    
    static func getDocControlPendingCapture(
        callback: @escaping ( (_ resp: APIResponseGeneric<[CustFiscalDocumentControlQuick]>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "getDocControlPendingCapture",
            EmptyPayload()
        ) { payload in
            guard let data = payload else{
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<[CustFiscalDocumentControlQuick]>.self, from: data)
                callback(resp)
            }
            catch{
                print(error)
                callback(nil)
            }
        }
        
    }
}
