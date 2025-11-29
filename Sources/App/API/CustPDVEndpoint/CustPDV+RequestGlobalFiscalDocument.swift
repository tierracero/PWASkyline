//
//  CustPDV+RequestGlobalFiscalDocument.swift
//
//
//  Created by Victor Cantu on 12/19/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustPDVComponents {
    
    static func requestGlobalFiscalDocument(
        documentsIds: [UUID],
        callback: @escaping ((
            _ resp: APIResponseGeneric<RequestGlobalFiscalDocumentResponse>?) -> ()
        )
    ) {
        sendPost(
            rout,
            version,
            "requestGlobalFiscalDocument",
            RequestGlobalFiscalDocumentRequest(
                documentsIds: documentsIds
            )
        ) { data in
            
                guard let data else {
                    callback(nil)
                    return
                }
            
                do{
                    let resp = try JSONDecoder().decode(APIResponseGeneric<RequestGlobalFiscalDocumentResponse>.self, from: data)
                    callback(resp)
                }
                catch{
                    print(error)
                    callback(nil)
                }
            
            }
    }
}
