//
//  CustPOC+AuditsVT.swift
//
//

import Foundation
import TCFireSignal
import TCFundamentals

extension CustPOCComponents {

    static func auditsVT(
        type: InventoryAuditTypes,
        storeid: UUID?,
        from: Int64,
        to: Int64,
        eventId: UUID,
        callback: @escaping ((_ response: APIResponseGeneric<AuditsVTResponse>?) -> Void)
    ) {
        sendPost(
            rout,
            version,
            "auditsVT",
            AuditsVTRequest(
                type: type,
                storeid: storeid,
                from: from,
                to: to,
                eventId: eventId
            )
        ) { payload in
            guard let payload else {
                callback(nil)
                return
            }

            do {
                let response = try decodeAPIResponse(
                    APIResponseGeneric<AuditsVTResponse>.self,
                    from: payload
                )
                callback(response)
            }
            catch {
                print(error)
                callback(nil)
            }
        }
    }
}
