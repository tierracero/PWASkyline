//
//  CustOrder+AddPayment.swift
//  
//
//  Created by Victor Cantu on 4/27/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustOrderEndpointV1 {
	
	static func addPayment (
		orderid: UUID,
        storeId: UUID,
		fiscCode: FiscalPaymentCodes,
		description: String,
		cost: Float,
		provider: String,
		lastFour: String,
		auth: String,
		callback: @escaping ( (_ resp: APIResponseGeneric<AddPaymentResponse>?) -> () )
	) {
		sendPost(
			rout,
			version,
			"addPayment",
            AddPaymentRequest(
                orderid: orderid, 
                storeId: storeId,
                fiscCode: fiscCode,
                description: description,
                cost: cost,
                provider: provider,
                lastFour: lastFour,
                auth: auth
            )
		) { data in
			guard let data else{
				callback(nil)
				return
			}
			do{
				callback(try JSONDecoder().decode(APIResponseGeneric<AddPaymentResponse>.self, from: data))
			}
			catch{
				callback(nil)
			}
		}
	}
}
