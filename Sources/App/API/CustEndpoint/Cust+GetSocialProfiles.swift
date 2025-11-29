//
//  Cust+GetSocialProfiles.swift
//  
//
//  Created by Victor Cantu on 10/11/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustComponents {
        
    static func getSocialProfiles(
        profileType: SocialProfileType,
        callback: @escaping ( (_ resp: [CustSocialProfileQuick]) -> () )
    ) {
        
        if !socialProfiles.isEmpty {
            callback(socialProfiles)
            return
        }
        
        loadingView(show: true)
        
        sendPost(
            rout,
            version,
            "getSocialProfiles",
            GetSocialProfilesRequest(
                profileType: profileType
            )
        ) { payload in
            
            loadingView(show: false)
            
            guard let data = payload else{
                callback([])
                return
            }
            
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<GetSocialProfilesResponse>.self, from: data)
                
                guard let profiles = resp.data?.profiles else {
                    callback([])
                    return
                }
                
                /// CustSocialProfileQuick
                socialProfiles = profiles.map{ .init(
                    id: $0.id,
                    createdAt: $0.createdAt,
                    modifiedAt: $0.modifiedAt,
                    expireAt: $0.expireAt,
                    profileType: $0.profileType,
                    vendorid: $0.vendorid,
                    name: $0.name,
                    avatar: $0.avatar
                ) }
                
                callback(socialProfiles)
                
            }
            catch{
                callback([])
            }
        }
    }
}
