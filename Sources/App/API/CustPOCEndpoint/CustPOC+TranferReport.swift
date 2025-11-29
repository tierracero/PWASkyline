//
//  CustPOC+TranferReport.swift
//
//
//  Created by Victor Cantu on 10/8/24.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustPOCComponents {
    
    static func tranferReport(
        fromStore: UUID,
        toStore: UUID,
        startAt: Int64,
        endAt: Int64,
        callback: @escaping ( (_ resp: APIResponseGeneric<TranferReportResponse>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "tranferReport",
            TranferReportRequest(
                fromStore: fromStore,
                toStore: toStore,
                startAt: startAt,
                endAt: endAt
            )
        ) { data in
            guard let data else{
                callback(nil)
                return
            }
            do{
                callback(try JSONDecoder().decode(APIResponseGeneric<TranferReportResponse>.self, from: data))
            }
            catch{
                print("🔴  🔴  🔴  🔴  🔴  🔴  🔴  🔴  🔴  🔴  🔴  🔴  🔴  🔴  🔴  🔴  ")
                print(error)
                callback(nil)
            }
        }
    }
}
