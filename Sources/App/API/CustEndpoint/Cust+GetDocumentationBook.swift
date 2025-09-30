//
//  Cust+GetDocumentationBook.swift
//  
//
//  Created by Victor Cantu on 6/15/24.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustAPIEndpointV1 {
    
    static func getDocumentationBook(
        bookId: UUID,
        callback: @escaping ( (_ resp: APIResponseGeneric<GetDocumentationBookResponse>?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "getDocumentationBook",
            GetDocumentationBookRequest(
                bookId: bookId
            )
        ) { data in
            guard let data else{
                callback(nil)
                return
            }
            do{
                callback(try JSONDecoder().decode(APIResponseGeneric<GetDocumentationBookResponse>.self, from: data))
            }
            catch{
                print("🔴 API_DECODING_ERROR")
                print(error)
                callback(nil)
            }
        }
    }
}
