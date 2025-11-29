//
//  Cust+CorrectImageSizeRegistration.swift
//  
//
//  Created by Victor Cantu on 1/31/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustComponents {
    
    static func correctImageSizeRegistration(
        type: CorrectImageSizeRegistrationType,
        relid: UUID,
        fileid: UUID,
        fileName: String,
        callback: @escaping ( (_ resp: APIResponseGeneric<CorrectImageSizeRegistrationResponse>?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "correctImageSizeRegistration",
            CorrectImageSizeRegistrationRequest(
                type: type,
                relid: relid,
                fileid: fileid,
                fileName: fileName
            )
        ) { payload in
            guard let data = payload else{
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<CorrectImageSizeRegistrationResponse>?.self, from: data)
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

