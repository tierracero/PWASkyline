// DELETEME
//  Cust+GetPublicTemporaryToken.swift
//  
//
//  Created by Victor Cantu on 6/8/23.
//
/*
import Foundation
import TCFundamentals
import TCFireSignal

extension CustComponents {
        
    public static func getPublicTemporaryToken(
        token: String,
        type: PublicTemporaryTokenRequestType,
        folio: String,
        pin: String,
        mobile: String,
        callback: @escaping ( (_ resp: APIResponseGeneric<String>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "getPublicTemporaryToken",
            GetPublicTemporaryTokenRequest(
                token: token,
                type: type,
                folio: folio,
                pin: pin,
                mobile: mobile
            )
        ) { payload in
            
            guard let payload else {
                callback(nil)
                return
            }
            
            do{
                callback(try JSONDecoder().decode(APIResponseGeneric<String>.self, from: payload))
            }
            catch {
                callback(nil)
            }
            
        }
    }
}
*/

