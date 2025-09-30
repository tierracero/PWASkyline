//
//  CustOrder+EquipmentPickedStatus.swift
//  
//
//  Created by Victor Cantu on 7/23/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustOrderEndpointV1 {
    
    static func equipmentPickedStatus(
        accountid: UUID,
        orderid: UUID,
        orderFolio: String,
        equipmentid: UUID,
        name: String,
        pickedUp: Bool,
        callback: @escaping ( (_ resp: APIResponseGeneric<EquipmentPickedStatusResponse>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "equipmentPickedStatus",
            EquipmentPickedStatusRequest(
                accountid: accountid,
                orderid: orderid,
                orderFolio: orderFolio,
                equipmentid: equipmentid,
                name: name,
                pickedUp: pickedUp
            )
        ) { resp in
            guard let data = resp else{
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<EquipmentPickedStatusResponse>.self, from: data)
                callback(resp)
            }
            catch{
                print("🔴 API_DECODING_ERROR")
                print(error)
                callback(nil)
            }
        }
    }
    
}
