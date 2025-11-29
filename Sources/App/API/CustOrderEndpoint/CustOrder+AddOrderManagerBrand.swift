//
//  CustOrder+AddOrderManagerBrand.swift
//  
//
//  Created by Victor Cantu on 8/15/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustOrderComponents {
    
    ///  Send OrderID to retive notes
    static func addOrderManagerBrand (
        term: String,
        callback: @escaping ( (_ resp: APIResponseGeneric<AddOrderManagerBrandResponse>?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "addOrderManagerBrand",
            AddOrderManagerBrandRequest(
                term: term
            )
        ) { resp in
            
            guard let data = resp else{
                callback(nil)
                return
            }
            
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<AddOrderManagerBrandResponse>.self, from: data)
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
