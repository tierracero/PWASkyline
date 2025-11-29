//
//  Cust+GetScheduleProfiles.swift
//  
//
//  Created by Victor Cantu on 9/7/25.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustComponents {
    static func getScheduleProfiles(
        callback: @escaping ( (_ resp: APIResponseGeneric<GetScheduleProfilesResponse>?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "getScheduleProfiles",
            EmptyPayload()
        ) { data in
            guard let data else{
                callback(nil)
                return
            }
            do{
                callback(try JSONDecoder().decode(APIResponseGeneric<GetScheduleProfilesResponse>.self, from: data))
            }
            catch {
                callback(nil)
            }
        }
    }
}
