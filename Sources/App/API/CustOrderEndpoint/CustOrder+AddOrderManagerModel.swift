//
//  CustOrder+AddOrderManagerModel.swift
//  
//
//  Created by Victor Cantu on 8/15/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustOrderComponents {
    
    ///  Send OrderID to retive notes
    static func addOrderManagerModel (
        typeId: UUID,
        brandId: UUID,
        term: String,
        callback: @escaping ( (_ resp: APIResponseGeneric<CustOrderManagerModel>?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "addOrderManagerModel",
            AddOrderManagerModelRequest(
                typeId: typeId,
                brandId: brandId,
                term: term
            )
        ) { resp in
            guard let data = resp else{
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<CustOrderManagerModel>.self, from: data)
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
