//
//  CustPOC+AuditProductActivity.swift
//

import Foundation
import TCFireSignal
import TCFundamentals

extension CustPOCComponents {

    static func auditProductActivity(
        from: Int64,
        to: Int64,
        callback: @escaping ((_ response: APIResponseGeneric<AuditProductActivityResponse>?) -> Void)
    ) {
        sendPost(
            rout,
            version,
            "auditProductActivity",
            AuditProductActivityRequest(
                from: from,
                to: to
            )
        ) { payload in
            guard let payload else {
                callback(nil)
                return
            }

            do {
                callback(try decodeAPIResponse(
                    APIResponseGeneric<AuditProductActivityResponse>.self,
                    from: payload
                ))
            }
            catch {
                print(error)
                callback(nil)
            }
        }
    }
}
