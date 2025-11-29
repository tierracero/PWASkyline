//
//  Fiscal+Delete.swift
//  
//
//  Created by Victor Cantu on 3/1/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension FiscalComponents {
    
    static func delete(
        id: UUID,
        motive: FiscalCancelDocumentMotive,
        reason: String,
        callback: @escaping ( (_ resp: APIResponseGeneric<DeleteResponse>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "delete",
            DeleteRequest(
                id: id,
                motive: motive,
                reason: reason
            )
        ) { payload in
            
            guard let data = payload else{
                callback(nil)
                return
            }
            
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<DeleteResponse>.self, from: data)
                callback(resp)
            }
            catch{
                print(error)
                callback(nil)
            }
            
        }
    }
}
