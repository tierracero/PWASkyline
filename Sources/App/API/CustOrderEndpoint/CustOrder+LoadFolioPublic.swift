// DELETEME
//  CustOrder+LoadFolioPublic.swift
//  
//
//  Created by Victor Cantu on 6/7/23.
//
/*
import Foundation
import TCFundamentals
import TCFireSignal

extension CustOrderComponents {
    public static func loadFolioPublic (
        identifier: HybridIdentifier,
        token: String,
        pin: String,
        callback: @escaping ( (_ resp: APIResponseGeneric<LoadFolioPublicResponse>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "loadFolioPublic",
            LoadFolioPublicRequest(
                identifier: identifier,
                token: token,
                pin: pin
            )
        ) { resp in
            guard let data = resp else {
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<LoadFolioPublicResponse>.self, from: data)
                callback(resp)
            }
            catch{
                print(error)
                callback(nil)
            }
        }
        
    }
}
*/
