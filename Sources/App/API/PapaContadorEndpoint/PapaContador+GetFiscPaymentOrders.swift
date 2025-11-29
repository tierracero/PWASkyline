//
//  PapaContador+GetFiscPaymentOrders.swift
//  
//
//  Created by Victor Cantu on 6/4/22.
//

import Foundation
import Foundation
import TCFundamentals
import TCFireSignal
/*
extension PapaContadorComponents {
    
    public static func getFiscPaymentOrders(
        fiaccount: UUID,
        loadType: GetFiscPaymentOrdersType,
        callback: @escaping ( (_ resp: APIResponseGeneric<GetFiscPaymentOrdersResponse>?) -> () )) {
        
        sendPost(
            rout,
            version,
            "getFiscPaymentOrders",
            GetFiscPaymentOrdersRequest(
                fiaccount: fiaccount,
                loadType: loadType
            )
        ) { payload in
            guard let data = payload else{
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<GetFiscPaymentOrdersResponse>.self, from: data)
                callback(resp)
            }
            catch{
                print("⭕️ getFiscPaymentOrders")
                print(error)
                callback(nil)
            }
        }
    }
}
*/