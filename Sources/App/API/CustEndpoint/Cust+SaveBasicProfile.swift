//
//  Cust+SaveBasicProfile.swift
//
//
//  Created by Victor Cantu on 8/28/24.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustComponents {
        
    static func saveBasicProfile(
        pageProfile: GeneralPageProfile,
        socialProfile: CustSocialConfiguration,
        callback: @escaping ( (_ resp: APIResponse?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "saveBasicProfile",
            SaveBasicProfilesRequest(
                pageProfile: pageProfile,
                socialProfile: socialProfile
            )
        ) { data in
            
            guard let data else {
                callback(nil)
                return
            }
            
            do{
                let resp = try JSONDecoder().decode(APIResponse.self, from: data)
                callback(resp)
            }
            catch{
                print("🔴 API_DECODING_ERROR")
                print(error)
                callback(nil)
            }
        }
    }
}

