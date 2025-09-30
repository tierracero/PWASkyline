//
//  CustOrder+AddCustProjectCharge.swift
//
//
//  Created by Victor Cantu on 10/4/24.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustOrderEndpointV1 {
    
    static func addCustProjectCharge (
        projectId: UUID,
        units: Int,
        cost: Int64,
        name: String,
        callback: @escaping ( (_ resp: APIResponseGeneric<CustOrderProjetcManagerCharge>?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "addCustProjectCharge",
            AddCustProjectChargeRequest(
                projectId: projectId,
                units: units,
                cost: cost,
                name: name
            )
        ) { data in
            guard let data else{
                
                callback(nil)
                return
            }
            do{
                callback(try JSONDecoder().decode(APIResponseGeneric<CustOrderProjetcManagerCharge>.self, from: data))
            }
            catch{
                print("🔴 API_DECODING_ERROR")
                print(error)
                callback(nil)
            }
        }
    }
}
