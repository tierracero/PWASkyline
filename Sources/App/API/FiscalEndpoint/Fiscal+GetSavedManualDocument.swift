//
//  Fiscal+GetSavedManualDocument.swift
//
//
//  Created by Victor Cantu on 10/2/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension FiscalEndpointV1{
    
    static func getSavedManualDocument(
        id: UUID,
        callback: @escaping ( (_ resp: APIResponseGeneric<GetSavedManualDocumentResponse>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "getSavedManualDocument",
            GetSavedManualDocumentRequest(
                id: id
            )
        ) { payload in
            guard let data = payload else{
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<GetSavedManualDocumentResponse>.self, from: data)
                callback(resp)
            }
            catch{
                print(error)
                callback(nil)
            }
        }
        
    }
}

