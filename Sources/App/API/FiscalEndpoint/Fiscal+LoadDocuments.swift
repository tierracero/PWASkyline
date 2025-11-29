//
//  Fiscal+LoadDocuments.swift
//  
//
//  Created by Victor Cantu on 2/25/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension FiscalComponents {
    
    static func loadDocuments(
        id: UUID?,
        callback: @escaping ( (_ resp: APIResponseGeneric<LoadDocumentsResponse>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "loadDocuments",
            APIRequestIDOptional(
                id: id,
                store: nil
            )
        ) { payload in
            guard let data = payload else{
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<LoadDocumentsResponse>.self, from: data)
                callback(resp)
            }
            catch{
                print(error)
                callback(nil)
            }
        }
        
    }
}
