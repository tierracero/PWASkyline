//
//  Cust+GetInstagramPages.swift
//  
//
//  Created by Victor Cantu on 12/31/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustAPIEndpointV1 {
        
    static func getInstagramPages(
        fbpageid: String,
        callback: @escaping ( (_ resp: APIResponseGeneric<GetInstagramPagesResponse>?) -> () )
    ) {
        
        loadingView(show: true)
        
        print("🐼  getInstagramPages  🐼  ")
        
        sendPost(
            rout,
            version,
            "getInstagramPages",
            GetInstagramPagesRequest(
                fbpageid: fbpageid
            )
        ) { payload in
            
            loadingView(show: false)
            
            guard let data = payload else{
                callback(nil)
                return
            }
            
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<GetInstagramPagesResponse>.self, from: data)
                
                callback(resp)
                
            }
            catch {
                
                callback(nil)
            }
            
        }
    }
}


