//
//  CustOrder+GetDigitalContract.swift
//
//
//  Created by Victor Cantu on 6/21/24.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustOrderComponents {
    static func getDigitalContract(
        orderId: UUID,
        callback: @escaping ( (_ resp: APIResponseGeneric<GetDigitalContractResponse>?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "getDigitalContract",
            GetDigitalContractRequest(
                orderId: orderId
            )
        ) { data in
            guard let data else{
                callback(nil)
                return
            }
            do{
                callback(try decodeAPIResponse(APIResponseGeneric<GetDigitalContractResponse>.self, from: data))
            }
            catch {
                callback(nil)
            }
        }
    }
}
