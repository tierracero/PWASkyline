//
//  CustPDV+GetSales.swift
//  
//
//  Created by Victor Cantu on 5/16/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustPDVEndpointV1 {
    
    static func getSales(
        type: SalesReportTypes,
        id: UUID?,
        startAt: Int64,
        endAt: Int64,
        requestedIds: [UUID],
        callback: @escaping ((
            _ resp: APIResponseGeneric<GetSalesResponse>?) -> ()
        )
    ) {
        
        sendPost(
            rout,
            version,
            "getSales",
            GetSalesRequest(
                type: type,
                id: id,
                startAt: startAt,
                endAt: endAt,
                requestedIds: requestedIds
            )
        ) { resp in
            
                guard let data = resp else {
                    callback(nil)
                    return
                }
            
                do{
                    let resp = try JSONDecoder().decode(APIResponseGeneric<GetSalesResponse>.self, from: data)
                    callback(resp)
                }
                catch{
                    print(error)
                    callback(nil)
                }
            
            }
    }
}
