//
//  CustPOC+GetInventoryTransferReport.swift
//
//
//  Created by Victor Cantu on 5/14/24.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustPOCComponents {
    
    static func getInventoryTransferReport(
        type: GetInventoryTransferReportType,
        id: UUID,
        from: Int64,
        to: Int64,
        callback: @escaping ( (_ resp: APIResponseGeneric<GetInventoryTransferReportResponse>?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "getInventoryTransferReport",
            GetInventoryTransferReportRequest(
                type: type,
                id: id,
                from: from,
                to: to
            )
        ) { data in
            
            guard let data else{
                callback(nil)
                return
            }
            do{
                callback(try JSONDecoder().decode(APIResponseGeneric<GetInventoryTransferReportResponse>.self, from: data))
            }
            catch{
                print(error)
                callback(nil)
            }
        }
    }
}
