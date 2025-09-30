//
//  CustPOC+RemoveMedia.swift
//  
//
//  Created by Victor Cantu on 2/5/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustPOCEndpointV1 {
    
    /// Will delete image, if autoRemoval then it will restore image  form OG IMG
    static func removeMedia(
        poc: UUID,
        id: UUID,
        img: String,
        autoRemoval: Bool,
        viewid: UUID,
        callback: @escaping ( (_ resp: APIResponseGeneric<RemoveMediaResponseType>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "removeMedia",
            RemoveMediaRequest(
                poc: poc,
                id: id,
                img: img,
                autoRemoval: autoRemoval, 
                viewid: viewid
            )
        ) { payload in
            guard let data = payload else{
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<RemoveMediaResponseType>.self, from: data)
                callback(resp)
            }
            catch{
                print(error)
                callback(nil)
            }
        }
    }
}
