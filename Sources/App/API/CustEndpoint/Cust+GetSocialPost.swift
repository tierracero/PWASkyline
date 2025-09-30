//
//  Cust+GetSocialPost.swift
//  
//
//  Created by Victor Cantu on 4/12/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustAPIEndpointV1 {
        
    static func getSocialPost(
        mainid: UUID,
        callback: @escaping ( (_ resp: APIResponseGeneric<GetSocialPostResponse>?) -> () )
    ) {
        
        loadingView(show: true)
        
        sendPost(
            rout,
            version,
            "getSocialPost",
            GetSocialPostRequest(
                mainid: mainid
            )
        ) { payload in
            
            loadingView(show: false)
            
            guard let data = payload else{
                callback( nil )
                return
            }
            
            do{
                
                let resp = try JSONDecoder().decode(APIResponseGeneric<GetSocialPostResponse>.self, from: data)
                
                callback(resp)
                
            }
            catch{
                callback( nil )
            }
        }
    }
}
