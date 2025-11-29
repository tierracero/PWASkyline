//
//  Fiscal+GetProfile.swift
//  
//
//  Created by Victor Cantu on 7/26/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension FiscalComponents {
    
    static func getProfile(
        type: FIAccountsServicesRelatedType,
        relation: UUID?,
        callback: @escaping ( (_ resp: APIResponseGeneric<GetProfileResponse>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "getProfile",
            GetProfileRequest(
                type: type,
                relation: relation
            )
        ) { payload in
            guard let data = payload else{
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<GetProfileResponse>.self, from: data)
                callback(resp)
            }
            catch{
                print(error)
                callback(nil)
            }
        }
        
    }
}
