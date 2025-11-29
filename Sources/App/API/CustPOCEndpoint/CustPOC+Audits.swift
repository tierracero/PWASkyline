//
//  CustPOC+Audits.swift
//  
//
//  Created by Victor Cantu on 7/10/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustPOCComponents {
    
    static func audits(
        type: InventoryAuditTypes,
        storeid: UUID?,
        userId: UUID?,
        depid: UUID?,
        accountId: UUID?,
        from: Int64?,
        to: Int64?,
        ids: [UUID]?,
        callback: @escaping ( (_ resp: APIResponseGeneric<AuditsResponse>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "audits",
            AuditsRequest(
                type: type,
                storeid: storeid, 
                userId: userId,
                depid: depid,
                accountId: accountId,
                from: from,
                to: to, 
                ids: ids
            )
        ) { payload in
            guard let data = payload else{
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<AuditsResponse>.self, from: data)
                callback(resp)
            }
            catch{
                print(error)
                callback(nil)
            }
        }
    }
}
