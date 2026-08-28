//
//  Cust+GetInstagramPageData.swift
//  
//
//  Created by Victor Cantu on 12/31/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustComponents {
        
    static func getInstagramPageData(
        fbpageid: String,
        igpageid: String,
        callback: @escaping ( (_ resp: APIResponseGeneric<GetInstagramPageDataResponse>?) -> () )
    ) {
        
        loadingView.show()
        
        print("🐼  getInstagramPages  🐼  ")
        
        sendPost(
            rout,
            version,
            "getInstagramPageData",
            GetInstagramPageDataRequest(
                fbpageid: fbpageid,
                igpageid: igpageid
            )
        ) { payload in
            
            loadingView.hide()
            
            guard let data = payload else{
                callback(nil)
                return
            }
            
            do{
                let resp = try decodeAPIResponse(APIResponseGeneric<GetInstagramPageDataResponse>.self, from: data)
                
                callback(resp)
                
            }
            catch {
                
                callback(nil)
            }
            
        }
    }
}



