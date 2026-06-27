//
//  Cust+GetCommunicationProfile.swift
//
//  Created by Victor Cantu on 6/21/26.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustComponents {
        
    static func getCommunicationProfile(
        callback: @escaping ( (_ resp: APIResponseGeneric<CustCommunicationProfile>? ) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "getCommunicationProfile",
            EmptyPayload()
        ) { data in
            
            guard let data else{
                callback(nil)
                return
            }
            
            do{
                callback(try JSONDecoder().decode(APIResponseGeneric<CustCommunicationProfile>.self, from: data))
            }
            catch {
                callback(nil)
            }
            
        }
    }
}
