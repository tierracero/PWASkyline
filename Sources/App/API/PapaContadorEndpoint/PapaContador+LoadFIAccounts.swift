//
//  PapaContador+LoadFIAccounts.swift
//  
//
//  Created by Victor Cantu on 8/29/22.
//

import Foundation
import TCFundamentals
import TCFireSignal
/*
extension PapaContadorComponents {
    public static func loadFIAccounts(callback: @escaping ( (_ resp: APIResponseGeneric<[FIAccounts]>?) -> () )) {
        
        sendPost(
            rout,
            version,
            "loadFIAccounts",
            EmptyPayload()
        ) { payload in
            guard let data = payload else{
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<[FIAccounts]>.self, from: data)
                callback(resp)
            }
            catch{
                print("⭕️ loadFIAccounts")
                print(error)
                callback(nil)
            }
        }
    }
}
*/