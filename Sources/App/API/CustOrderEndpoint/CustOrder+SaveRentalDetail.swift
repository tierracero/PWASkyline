//
//  CustOrder+SaveRentalDetail.swift
//  
//
//  Created by Victor Cantu on 5/2/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustOrderEndpointV1 {
	
	static func saveRentalDetail (
		accountid: UUID,
		orderid: UUID,
		rentalid: UUID,
		ecoNumber: String,
		description: String,
		callback: @escaping ( (_ resp: APIResponse?) -> () )
	) {
		
		sendPost(
			rout,
			version,
			"saveRentalDetail",
			SaveRentalDetailRequest(accountid: accountid, orderid: orderid, rentalid: rentalid, ecoNumber: ecoNumber, description: description)
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
