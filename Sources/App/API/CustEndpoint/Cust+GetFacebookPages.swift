//
//  Cust+GetFacebookPages.swift
//  
//
//  Created by Victor Cantu on 12/29/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustComponents {
        
    static func getFacebookPages(
        callback: @escaping ( (_ resp: [API.custAPIV1.GetPageList]) -> () )
    ) {
        
        loadingView.show()
        
        print("🐼  getFacebookPages  🐼  ")
        
        sendPost(
            rout,
            version,
            "getFacebookPages",
            EmptyPayload()
        ) { payload in
            
            loadingView.hide()
            
            guard let data = payload else {
                callback([])
                return
            }
            
            do{
                
                let resp = try decodeAPIResponse(APIResponseGeneric<[API.custAPIV1.GetPageList]>.self, from: data)
                
                guard let pages = resp.data else {
                    callback([])
                    return
                }
                
                callback(pages)
                
            }
            catch {
                
                callback([])
            }
            
        }
    }
}

