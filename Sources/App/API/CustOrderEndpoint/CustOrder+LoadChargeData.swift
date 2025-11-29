//
//  CustOrder+LoadChargeData.swift
//  
//
//  Created by Victor Cantu on 7/10/22.
//
import Foundation
import TCFundamentals
import TCFireSignal

extension CustOrderComponents {
    static func loadChargeData (
        ///product, service, manual, rental
        type: ChargeType,
        id: UUID,
        callback: @escaping ( (_ resp: APIResponseGeneric<LoadChargeDataResponse>?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "loadChargeData",
            LoadChargeDataRequest(
                type: type,
                id: id
            )
        ) { resp in
            guard let data = resp else {
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<LoadChargeDataResponse>.self, from: data)
                callback(resp)
            }
            catch{
                print(error)
                callback(nil)
            }
        }
    }
}

