//
//  Cust+RemoveBackground.swift
//  
//
//  Created by Victor Cantu on 10/7/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustComponents {
    
    static func removeBackground(
        eventid: UUID,
        to: ImagePickerTo,
        toId: UUID?,
        subId: CustWebFilesObjectType?,
        fileName: String,
        connid: String,
        roomtoken: String?,
        usertoken: String?,
        mid: String?,
        replyTo: String?,
        callback: @escaping ( (_ resp: APIResponse?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "removeBackground",
            RemoveBackgroundRequest(
                eventid: eventid,
                to: to,
                toId: toId, 
                subId: subId,
                fileName: fileName,
                connid: connid,
                roomtoken: roomtoken,
                usertoken: usertoken,
                mid: mid,
                replyTo: replyTo
            )
        ) { payload in
            guard let data = payload else{
                callback(nil)
                return
            }
            do{
                
                let resp = try JSONDecoder().decode(APIResponse.self, from: data)
                callback(resp)
                
            }
            catch{
                print(error)
                callback(nil)
            }
        }
    }
}
