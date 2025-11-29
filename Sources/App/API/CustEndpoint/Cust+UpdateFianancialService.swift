//
//  Cust+UpdateFianancialService.swift
//  
//
//  Created by Victor Cantu on 7/28/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustComponents {
    
    static func updateFianancialService(
        id: UUID,
        returned: Int64,
        vendorid: UUID,
        reciptType: FinacialServicesReciptType,
        reciptId: UUID?,
        reciptFolio: String,
        reciptImage: String?,
        callback: @escaping ( (_ resp: APIResponse?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "updateFianancialService",
            UpdateFianancialServiceRequest(
                id: id,
                returned: returned,
                vendorid: vendorid,
                reciptType: reciptType,
                reciptId: reciptId,
                reciptFolio: reciptFolio,
                reciptImage: reciptImage
            )
        ) { payload in
            guard let data = payload else{
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponse?.self, from: data)
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

