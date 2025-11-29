//
//  Customer+CustFreeTerm.swift
//
//
//  Created by Victor Cantu on 2/28/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustComponents {
    
    static func custFreeTerm(term: String, type: CustFreeTermTypes, custAcct: UUID?, callback: @escaping ( (_ resp: APIResponseGeneric<FreeTermResponse>?) -> () )) {
        
        sendPost(
            rout,
            version,
            "custFreeTerm",
            FreeTermRequest(term: term, type: type, custAcct: custAcct, accountid: custAcct)
        ) { payload in
            
            guard let data = payload else{
                callback(nil)
                return
            }
            
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<FreeTermResponse>.self, from: data)
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
