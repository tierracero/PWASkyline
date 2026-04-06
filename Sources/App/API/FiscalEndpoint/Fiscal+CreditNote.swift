//
//  Fiscal+CreditNote.swift
//  TCFireSignal
//
//  Created by Victor Cantu on 4/4/26.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension FiscalComponents {
    
    static func creditNote(
        id: UUID,
        credit: Int64,
        description: String,
        comment: String,
        storeId: UUID,
        callback: @escaping ( (_ resp: APIResponseGeneric<FIAccountsServices>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "creditNote",
            CreditNoteRequest(
                id: id,
                credit: credit,
                description: description,
                comment: comment,
                storeId: storeId
            )
        ) { data in
            
            guard let data else{
                callback(nil)
                return
            }
            
            do{
                callback(try JSONDecoder().decode(APIResponseGeneric<FIAccountsServices>.self, from: data))
            }
            catch{
                print(error)
                callback(nil)
            }
            
        }
    }
}
