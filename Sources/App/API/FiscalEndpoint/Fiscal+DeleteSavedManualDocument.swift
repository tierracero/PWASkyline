//
//  Fiscal+DeleteSavedManualDocument.swift
//  
//
//  Created by Victor Cantu on 10/3/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension FiscalEndpointV1 {
    
    static func deleteSavedManualDocument(
        id: UUID,
        callback: @escaping ( (_ resp: APIResponse?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "deleteSavedManualDocument",
            DeleteSavedManualDocumentRequest(
                id: id
            )
        ) { payload in
            
            guard let data = payload else{
                callback(nil)
                return
            }
            
            do{
                let resp = try JSONDecoder().decode(APIResponse.self, from: data)
                callback(resp)
            }
            catch{
                print(error)
                callback(nil)
            }
            
        }
    }
}
