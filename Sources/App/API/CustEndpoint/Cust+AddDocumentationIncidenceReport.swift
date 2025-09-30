//
//  Cust+AddDocumentationIncidenceReport.swift
//
//
//  Created by Victor Cantu on 6/15/24.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustAPIEndpointV1 {
    
    static func addDocumentationIncidenceReport(
        userId: UUID,
        articleId: UUID,
        isAccepted: Bool,
        amendmentSteps: String,
        callback: @escaping ( (_ resp: APIResponseGeneric<AddDocumentationIncidenceReportResponse>?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "addDocumentationIncidenceReport",
            AddDocumentationIncidenceReportRequest(
                userId: userId,
                articleId: articleId,
                isAccepted: isAccepted,
                amendmentSteps: amendmentSteps
            )
        ) { data in
            guard let data else{
                callback(nil)
                return
            }
            do{
                callback(try JSONDecoder().decode(APIResponseGeneric<AddDocumentationIncidenceReportResponse>?.self, from: data))
            }
            catch{
                print("🔴 API_DECODING_ERROR")
                print(error)
                callback(nil)
            }
        }
    }
}
