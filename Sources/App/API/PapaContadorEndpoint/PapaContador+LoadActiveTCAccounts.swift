//
//  PapaContador+LoadActiveTCAccounts.swift
//  
//
//  Created by Victor Cantu on 6/3/22.
//

import Foundation
import TCFundamentals
import TCFireSignal
/*
extension PapaContadorComponents {
    
    public static func loadActiveTCAccounts(callback: @escaping ( (_ resp: APIResponseGeneric<[LoadActiveTCAccountResponse]>?) -> () )) {
        
        sendPost(
            rout,
            version,
            "loadActiveTCAccounts",
            EmptyPayload()
        ) { payload in
            guard let data = payload else{
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<[LoadActiveTCAccountResponse]>.self, from: data)
                callback(resp)
            }
            catch{
                print("⭕️ loadActiveTCAccounts")
                print(error)
                callback(nil)
            }
        }
    }
}
*/