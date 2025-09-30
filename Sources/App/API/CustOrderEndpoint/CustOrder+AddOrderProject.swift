//
//  CustOrder+AddOrderProject.swift
//
//
//  Created by Victor Cantu on 10/2/24.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustOrderEndpointV1 {
    
    static func addOrderProject (
        supervisedBy: UUID,
        accountId: UUID,
        orderId: UUID,
        name: String,
        description: String,
        items: [AddOrderProjectItem],
        includeCurrentCharges: Bool,
        manualCharges: [AddOrderProjectCharge],
        callback: @escaping ( (_ resp: APIResponseGeneric<AddOrderProjectResponse>?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "addOrderProject",
            AddOrderProjectRequest(
                supervisedBy: supervisedBy,
                accountId: accountId,
                orderId: orderId,
                name: name,
                description: description,
                items: items,
                includeCurrentCharges: includeCurrentCharges,
                manualCharges: manualCharges
            )
        ) { data in
            guard let data else{
                callback(nil)
                return
            }
            do{
                callback(try JSONDecoder().decode(APIResponseGeneric<AddOrderProjectResponse>.self, from: data))
            }
            catch{
                print("🔴 API_DECODING_ERROR")
                print(error)
                callback(nil)
            }
        }
    }
}
