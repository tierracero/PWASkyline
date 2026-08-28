//
//  Cust+GetInstagramPages.swift
//  
//
//  Created by Victor Cantu on 12/31/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustComponents {
        
    static func getInstagramPages(
        fbpageid: String,
        callback: @escaping ( (_ resp: APIResponseGeneric<GetInstagramPagesResponse>?) -> () )
    ) {
        
        loadingView.show()
        
        print("🐼  getInstagramPages  🐼  ")
        
        sendPost(
            rout,
            version,
            "getInstagramPages",
            GetInstagramPagesRequest(
                fbpageid: fbpageid
            )
        ) { payload in
            
            loadingView.hide()
            
            guard let data = payload else{
                callback(nil)
                return
            }
            
            do{
                let resp = try decodeAPIResponse(APIResponseGeneric<GetInstagramPagesResponse>.self, from: data)
                
                callback(resp)
                
            }
            catch {
                
                callback(nil)
            }
            
        }
    }
}


