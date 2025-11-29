//
//  Cust+CreateFianancialService.swift
//  
//
//  Created by Victor Cantu on 7/28/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustComponents {
    
    static func createFinancialService(
        type: CreateFianancialServiceType,
        targetUser: UUID?,
        amount: Int64,
        description: String,
        vendorid: UUID?,
        vendorName: String?,
        reciptType: FinacialServicesReciptType?,
        reciptId: UUID?,
        reciptFolio: String?,
        reciptImage: String?,
        callback: @escaping ( (_ resp: APIResponseGeneric<CustUserFinacialServices>?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "createFinancialService",
            CreateFianancialServiceRequest(
                type: type,
                targetUser: targetUser,
                amount: amount,
                description: description,
                vendorid: vendorid,
                vendorName: vendorName,
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
                let resp = try JSONDecoder().decode(APIResponseGeneric<CustUserFinacialServices>?.self, from: data)
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

