//
//  CustPOC+CreateDispersionDocument.swift
//  
//
//  Created by Victor Cantu on 10/1/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustPOCEndpointV1 {
    
    static func createDispersionDocument(
        docid: UUID,
        storeid: UUID,
        items: [DispersionDocumentItem],
        callback: @escaping ( (_ resp: APIResponseGeneric<[UUID]>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "createDispersionDocument",
            CreateDispersionDocumentRequest(
                docid: docid,
                storeid: storeid,
                items: items
            )
        ) { payload in
            guard let data = payload else{
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<[UUID]>.self, from: data)
                callback(resp)
            }
            catch{
                print(error)
                callback(nil)
            }
        }
    }
}
