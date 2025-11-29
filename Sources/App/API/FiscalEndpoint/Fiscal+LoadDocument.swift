//
//  Fiscal+LoadDocument.swift
//  
//
//  Created by Victor Cantu on 2/27/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension FiscalComponents {
    
    static func loadDocument(
        docid: UUID,
        callback: @escaping ( (_ resp: APIResponseGeneric<LoadDocumentResponse>?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "loadDocument",
            APIRequestID(id: docid, store: nil)
        ) { payload in
            
            guard let data = payload else{
                callback(nil)
                return
            }
            
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<LoadDocumentResponse>.self, from: data)
                callback(resp)
            }
            catch{
                print(error)
                callback(nil)
            }
        }
        
    }
}
