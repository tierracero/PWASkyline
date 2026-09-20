//
//  CustPOC+CardexDetail.swift
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustPOCComponents {

    static func cardexDetail(
        relationId: UUID,
        pocId: UUID,
        startAt: Int64,
        endAt: Int64,
        callback: @escaping ((_ response: APIResponseGeneric<CardexDetailResponse>?) -> Void)
    ) {
        sendPost(
            rout,
            version,
            "cardexDetail",
            CardexDetailRequest(
                relationId: relationId,
                pocId: pocId,
                startAt: startAt,
                endAt: endAt
            )
        ) { payload in
            guard let payload else {
                callback(nil)
                return
            }

            do {
                callback(try decodeAPIResponse(
                    APIResponseGeneric<CardexDetailResponse>.self,
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
