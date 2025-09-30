//
//  CustOrder+RentalReadyStatus.swift
//  
//
//  Created by Victor Cantu on 5/1/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustOrderEndpointV1 {
	
	static func rentalReadyStatus (
		accountid: UUID,
		orderid: UUID,
        orderFolio: String,
		rentalid: UUID,
		ecoNumber: String,
		isReady: Bool,
		callback: @escaping ( (_ resp: APIResponse?) -> () )
	) {
		
		sendPost(
			rout,
			version,
			"rentalReadyStatus",
            RentalReadyStatusRequest(accountid: accountid, orderid: orderid, orderFolio: orderFolio, rentalid: rentalid, ecoNumber: ecoNumber, isReady: isReady)
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
				callback(nil)
			}
		}
		
	}
	
}
