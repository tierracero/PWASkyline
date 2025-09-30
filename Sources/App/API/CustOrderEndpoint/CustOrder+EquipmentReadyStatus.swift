//
//  CustOrder+EquipmentReadyStatus.swift
//  
//
//  Created by Victor Cantu on 7/23/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustOrderEndpointV1 {
    
    static func equipmentReadyStatus(
        accountid: UUID,
        orderid: UUID,
        orderFolio: String,
        equipmentid: UUID,
        name: String,
        isReady: Bool,
        callback: @escaping ( (_ resp: APIResponse?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "equipmentReadyStatus",
            EqupmentReadyStatusRequest(
                accountid: accountid,
                orderid: orderid,
                orderFolio: orderFolio,
                equipmentid: equipmentid,
                name: name,
                isReady: isReady
            )
        ) { resp in
            
            guard let data = resp else{
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponse.self, from: data)
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

