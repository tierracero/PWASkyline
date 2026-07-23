//
//  Cust+AddDocumentationBook.swift
//  
//
//  Created by Victor Cantu on 6/15/24.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustComponents {
    
    static func addDocumentationBook(
        type: CustDocumentationBookType,
        subType: CustDocumentationBookSubType?,
        name: String,
        description: String,
        callback: @escaping ( (_ resp: APIResponseGeneric<CustDocumentationBookManager>?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "addDocumentationBook",
            AddDocumentationBookRequest(
                type: type,
                subType: subType,
                name: name,
                description: description
            )
        ) { data in
            
            guard let data else {
                callback(nil)
                return
            }
            
            do{
                callback(try decodeAPIResponse(APIResponseGeneric<CustDocumentationBookManager>.self, from: data))
            }
            catch{
                print("🔴 API_DECODING_ERROR")
                print(error)
                callback(nil)
            }
            
        }
    }
}
