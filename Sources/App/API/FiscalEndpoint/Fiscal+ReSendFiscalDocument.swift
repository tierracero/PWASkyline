//
//  Fiscal+ReSendFiscalDocument.swift
//
//
//  Created by Victor Cantu on 1/27/24.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension FiscalEndpointV1 {
    
    static func reSendFiscalDocument(
        fiscalId: UUID,
        method: String,
        callback: @escaping ( (_ resp: APIResponse?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "reSendFiscalDocument",
            ReSendFiscalDocumentRequest(
                fiscalId: fiscalId,
                method: method
            )
        ) { payload in
            
            guard let payload else{
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
