//
//  CustPDV+SendToConcession.swift
//
//
//  Created by Victor Cantu on 1/5/24.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustPDVEndpointV1 {
    
    static func sendToConcession(
        token: String,
        storeId: UUID,
        accountId: UUID,
        items: [SaleObjectItem],
        callback: @escaping ((
            _ resp: APIResponseGeneric<SendToConcessionResponse>?) -> ()
        )
    ) {
        sendPost(
            rout,
            version,
            "sendToConcession",
            SendToConcessionRequest(
                token: token,
                storeId: storeId,
                accountId: accountId,
                items: items
            )
        ) { data in
            
                guard let data else {
                    callback(nil)
                    return
                }
            
                do{
                    let resp = try JSONDecoder().decode(APIResponseGeneric<SendToConcessionResponse>.self, from: data)
                    callback(resp)
                }
                catch{
                    print(error)
                    callback(nil)
                }
            
            }
    }
}
