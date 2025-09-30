//
//  CustPOC+CreateManualDispersionDocument.swift
//  
//
//  Created by Victor Cantu on 11/21/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustPOCEndpointV1 {
    
    static func createManualDispersionDocument(
        docId: UUID,
        items: [DispersionDocumentManualItem],
        callback: @escaping (
            (_ resp: APIResponseGeneric<CreateManualDispersionDocumentResponse>?) -> ()
        )
    ) {
        sendPost(
            rout,
            version,
            "createManualDispersionDocument",
            CreateManualDispersionDocumentRequest(
                docId: docId,
                items: items
            )
        ) { payload in
            guard let data = payload else{
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<CreateManualDispersionDocumentResponse>.self, from: data)
                callback(resp)
            }
            catch{
                print(error)
                callback(nil)
            }
        }
    }
}

