//
//  CustOrder+Report.swift
//
//
//  Created by Victor Cantu on 10/16/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustOrderEndpointV1 {
    
    static func reports (
        type: OrderReportTypes,
        storeId: UUID?,
        userId: UUID?,
        from: Int64?,
        to: Int64?,
        callback: @escaping ( (_ resp: APIResponseGeneric<ReportResponseType>?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "reports",
            ReportsRequest(
                type: type,
                storeId: storeId,
                userId: userId,
                from: from,
                to: to,
                tag1: nil,
                tag2: nil,
                tag3: nil
            )
        ) { resp in
            guard let data = resp else{
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<ReportResponseType>.self, from: data)
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
