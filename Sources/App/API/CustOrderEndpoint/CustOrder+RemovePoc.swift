//
//  CustOrder+RemovePoc.swift
//  
//
//  Created by Victor Cantu on 7/9/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustOrderComponents {
    
    /// - Parameters:
    ///   - orderId: Order UUID
    ///   - orderFolio: Order Folio
    ///   - ids: [UUID]
    static func removePoc (
        orderId: UUID,
        orderFolio: String,
        ids: [UUID],
        callback: @escaping ( (_ resp: APIResponseGeneric<RemovePOCResponse>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "removePoc",
            RemovePOCRequest(
                orderId: orderId,
                orderFolio: orderFolio,
                ids: ids
            )
        ) { resp in
            guard let data = resp else{
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<RemovePOCResponse>.self, from: data)
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

