//
//  Fiscal+GetSavedManualDocuments.swift
//
//
//  Created by Victor Cantu on 10/2/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension FiscalComponents {
    
    static func getSavedManualDocuments(
        callback: @escaping ( (_ resp: APIResponseGeneric<[SavedManualDocumentObject]>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "getSavedManualDocuments",
            EmptyPayload()
        ) { data in
            guard let data else{
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<[SavedManualDocumentObject]>.self, from: data)
                callback(resp)
            }
            catch{
                print(error)
                callback(nil)
            }
        }
        
    }
}
