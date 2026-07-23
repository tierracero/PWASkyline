//
//  Fiscal+GetCartaPorteHistory.swift
//  
//
//  Created by Victor Cantu on 2/24/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension FiscalComponents {
    
    static func getCartaPorteHistory(
        callback: @escaping ( (_ resp: APIResponseGeneric<[CustFiscalCartaPorteItem]>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "getCartaPorteHistory",
            EmptyPayload()
        ) { payload in
            
            guard let data = payload else{
                callback(nil)
                return
            }
            
            do{
                let resp = try decodeAPIResponse(APIResponseGeneric<[CustFiscalCartaPorteItem]>.self, from: data)
                callback(resp)
            }
            catch{
                print(error)
                callback(nil)
            }
        }
    }
}
