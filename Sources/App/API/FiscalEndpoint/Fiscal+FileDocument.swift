//
//  Fiscal+FileDocument.swift
//  
//
//  Created by Victor Cantu on 5/7/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension FiscalComponents {
    
    static func fileDocument(
        docid: UUID,
        reason: String,
        itemCount: Int,
        callback: @escaping ( (_ resp: APIResponse?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "fileDocument",
            FileDocumentRequest(
                docid: docid,
                reason: reason,
                itemCount: itemCount
            )
        ) { payload in
            
            guard let payload else {
                callback(nil)
                return
            }
            
            do{
                let resp = try JSONDecoder().decode(APIResponse.self, from: payload)
                callback(resp)
            }
            catch{
                print(error)
                callback(nil)
            }
            
        }
    }
}
