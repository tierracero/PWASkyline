//
//  CustOrder+AddCharge.swift
//
//
//  Created by Victor Cantu on 7/9/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustOrderEndpointV1 {
    
    ///  Send OrderID to retive notes
    static func addCharge (
        orderid: UUID,
        store: UUID,
        /// UUUID of POC of SOC
        id: UUID?,
        ///Incase of POC, list of uuid's, inventory.
        ids: [UUID],
        series: String?,
        ///service, product, manual, payment
        type: ChargeType,
        fiscCode: String,
        fiscUnit: String,
        code: String,
        description: String,
        quant: Float,
        price: Float,
        cost: Float?,
        isWarenty: Bool,
        internalWarenty: Bool?,
        generateRepositionOrder: Bool?,
        callback: @escaping ( (_ resp: APIResponseGeneric<API.custOrderV1.AddChargeResponse>?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "addCharge",
            AddChargeRequest(
                orderid: orderid,
                store: store,
                /// UUUID of POC of SOC
                id: id,
                ///Incase of POC, list of uuid's, inventory.
                ids: ids,
                series: series,
                ///service, product, manual, payment
                type: type,
                fiscCode: fiscCode,
                fiscUnit: fiscUnit,
                code: code,
                description: description,
                quant: quant,
                price: price,
                cost: cost,
                isWarenty: isWarenty,
                internalWarenty: internalWarenty,
                generateRepositionOrder: generateRepositionOrder
            )
        ) { data in
            
            guard let data else{
                
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<API.custOrderV1.AddChargeResponse>.self, from: data)
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

