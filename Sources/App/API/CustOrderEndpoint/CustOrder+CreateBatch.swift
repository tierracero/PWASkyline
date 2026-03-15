//
//  CustOrder+CreateBatch.swift
//
//
//  Created by Victor Cantu on 5/29/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustOrderComponents {
    
    static func createBatch(
        type: FolioTypes,
        storeId: UUID,
        custAcct: UUID,
        custSubAcct: UUID?,
        items: [OrderExtractPayload],
        callback: @escaping ( (_ resp: APIResponseGeneric<CreateBatchResponse>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "createBatch",
            CreateBatchRequest(
                type: type,
                storeId: storeId,
                custAcct: custAcct,
                custSubAcct: custSubAcct,
                items: items
            )
        ) { data in
            
            guard let data else {
                callback(nil)
                return
            }
            
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<CreateBatchResponse>.self, from: data)
                callback(resp)
            }
            catch{
                
                print("🔴  DECODING ERROR  🔴")
                
                print(error)
                
                callback(nil)
            }
            
        }
    }
    
}

