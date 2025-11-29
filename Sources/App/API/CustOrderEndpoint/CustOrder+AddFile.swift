//
//  CustOrder+AddFile.swift
//  
//
//  Created by Victor Cantu on 8/23/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustOrderComponents {
    
    static func addFile (
        accountid: UUID,
        orderid: UUID,
        orderFolio: String,
        base64: String?,
        fileName: String,
        /// Order Name
        name: String,
        /// Order Mobile
        mobile: String,
        /// sms, whatsapp, telegram, mlibre, wallmart, siweapp, chat
        lastCommunicationMethod: MessagingCommunicationMethods?,
        callback: @escaping ( (_ resp: ApiResponseGeneric<AddNoteResponse>?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "addFile",
            AddFileRequest(
                accountid: accountid,
                orderid: orderid,
                orderFolio: orderFolio,
                base64: base64,
                fileName: fileName,
                /// Order Name
                name: name,
                /// Order Mobile
                mobile: mobile,
                /// sms, whatsapp, telegram, mlibre, wallmart, siweapp, chat
                lastCommunicationMethod: lastCommunicationMethod
            )
        ) { resp in
            guard let data = resp else{
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(ApiResponseGeneric<AddNoteResponse>.self, from: data)
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

