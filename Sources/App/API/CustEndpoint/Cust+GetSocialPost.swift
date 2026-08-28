//
//  Cust+GetSocialPost.swift
//  
//
//  Created by Victor Cantu on 4/12/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustComponents {
        
    static func getSocialPost(
        mainid: UUID,
        callback: @escaping ( (_ resp: APIResponseGeneric<GetSocialPostResponse>?) -> () )
    ) {
        
        loadingView.show()
        
        sendPost(
            rout,
            version,
            "getSocialPost",
            GetSocialPostRequest(
                mainid: mainid
            )
        ) { payload in
            
            loadingView.hide()
            
            guard let data = payload else{
                callback( nil )
                return
            }
            
            do{
                
                let resp = try decodeAPIResponse(APIResponseGeneric<GetSocialPostResponse>.self, from: data)
                
                callback(resp)
                
            }
            catch{
                callback( nil )
            }
        }
    }
}
