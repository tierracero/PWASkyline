//
//  Cust+GetSocialAccountRefrence.swift
//  
//
//  Created by Victor Cantu on 4/21/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustAPIEndpointV1 {
        
    static func getSocialAccountRefrence(
        id: HybridIdentifier?,
        callback: @escaping ( (_ resp:  [CustSocialAccounts]) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "getSocialAccountRefrence",
            GetSocialAccountRefrenceRequest(
                id: id
            )
        ) { payload in
            
            loadingView(show: false)
            
            guard let data = payload else{
                callback([])
                return
            }
            
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<[CustSocialAccounts]>.self, from: data)
                
                guard let accounts = resp.data else {
                    callback([])
                    return
                }
                
                callback(accounts)
                
            }
            catch{
                callback([])
            }
            
        }
    }
}
