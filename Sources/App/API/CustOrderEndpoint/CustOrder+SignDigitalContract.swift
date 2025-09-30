//
//  CustOrder+SignDigitalContract.swift
//
//
//  Created by Victor Cantu on 6/21/24.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustOrderEndpointV1 {
    static func signDigitalContract(
        officeQAScore: Int?,
        operationQAScore: Int?,
        signiture: String,
        orderId: UUID,
        callback: @escaping ( (_ resp: APIResponseGeneric<SignDigitalContractResponse>?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "signDigitalContract",
            SignDigitalContractRequest(
                officeQAScore: officeQAScore,
                operationQAScore: operationQAScore,
                signiture: signiture,
                orderId: orderId
            )
        ) { data in
            guard let data else{
                callback(nil)
                return
            }
            do{
                callback(try JSONDecoder().decode(APIResponseGeneric<SignDigitalContractResponse>.self, from: data))
            }
            catch {
                callback(nil)
            }
        }
    }
}
