//
//  CustPDV+RemoveFromConcession.swift
//  
//
//  Created by Victor Cantu on 1/11/24.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustPDVComponents {
    
    /// Send products linked to a cutomer that are curently in consession
    /// - Parameters:
    ///   - type: return, sale(RemoveFromConcessionPayment)
    ///   - accountId:
    ///   - storeId:
    ///   - items:
    ///   - comments:
    ///   - callback: return(CustFiscalInventoryControl), sale(CloseSaleResponse)
    static func removeFromConcession(
        type: RemoveFromConcessionType,
        accountId: UUID,
        storeId: UUID,
        items: [UUID],
        comments: String,
        receptorRfc: String,
        callback: @escaping ((
            _ resp: APIResponseGeneric<RemoveFromConcessionResponseType>?) -> ()
        )
    ) {
        
        sendPost(
            rout,
            version,
            "removeFromConcession",
            RemoveFromConcessionRequest(
               type: type,
               accountId: accountId,
               storeId: storeId,
               items: items,
               comments: comments, 
               receptorRfc: receptorRfc
           )
        ) { resp in
            
                guard let data = resp else {
                    callback(nil)
                    return
                }
            
                do{
                    let resp = try JSONDecoder().decode(APIResponseGeneric<RemoveFromConcessionResponseType>.self, from: data)
                    callback(resp)
                }
                catch{
                    print(error)
                    callback(nil)
                }
            
            }
    }
}
