//
//  Cust+AsyncUploadStatus.swift
//  
//
//  Created by Victor Cantu on 10/9/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustComponents {
        
    static func asyncCheckUploadStatus(
        /// upload, removeBackgrond, crop
        type: UploadManagerType,
        eventid: UUID,
        callback: @escaping ( (_ resp: APIResponseGeneric<AsyncUploadStatusResponse>?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "asyncCheckUploadStatus",
            AsyncUploadStatusObjectRequest(
                type: type,
                eventid: eventid
            )
        ) { data in
            
            guard let data else {
                callback(nil)
                return
            }
            
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<AsyncUploadStatusResponse>.self, from: data)
                callback(resp)
            }
            catch{
                print("🔴 API_DECODING_ERROR")
                print(error)
                callback(nil)
            }
        }
    }
}
