//
//  Cust+GetNominaProfiles.swift
//  
//
//  Created by Victor Cantu on 7/6/25.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustComponents {
    static func getNominaProfiles(
        callback: @escaping ( (_ resp: APIResponseGeneric<GetNominaProfilesResponse>?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "getNominaProfiles",
            EmptyPayload()
        ) { data in
            guard let data else{
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<GetNominaProfilesResponse>.self, from: data)
                callback(resp)
            }
            catch {
                callback(nil)
            }
        }
    }
}
