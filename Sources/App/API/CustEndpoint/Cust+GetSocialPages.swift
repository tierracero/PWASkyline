//
//  Cust+GetSocialPages.swift
//  
//
//  Created by Victor Cantu on 10/16/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustComponents {
        
    static func getSocialPages(
        profileType: SocialProfileType?,
        custSocialProfile: UUID?,
        callback: @escaping ( (_ resp: [CustSocialPageQuick]) -> () )
    ) {
        
        if !socialPages.isEmpty {
            callback(socialPages)
            return
        }
        
        loadingView(show: true)
        
        sendPost(
            rout,
            version,
            "getSocialPages",
            GetSocialPagesRequest(
                profileType: profileType,
                custSocialProfile: custSocialProfile
            )
        ) { payload in
            
            loadingView(show: false)
            
            guard let data = payload else{
                callback([])
                return
            }
            
            do{
                
                let resp = try JSONDecoder().decode(APIResponseGeneric<[CustSocialPage]>.self, from: data)
                
                guard let pages = resp.data else {
                    showError(.unexpectedResult, .unexpenctedMissingPayload)
                    callback([])
                    return
                }

                socialPages = pages.map{ .init(
                    id: $0.id,
                    createdAt: $0.createdAt,
                    modifiedAt: $0.modifiedAt,
                    expireAt: $0.modifiedAt,
                    profileType: $0.profileType,
                    custSocialProfile: $0.custSocialProfile,
                    pageid: $0.pageid,
                    username: $0.username,
                    name: $0.name,
                    avatar: $0.avatar
                ) }
                
                callback(socialPages)
                
            }
            catch{
                callback([])
            }
        }
    }
}
