//
//  CustOrder+RentalPicked.swift
//  
//
//  Created by Victor Cantu on 5/1/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustOrderComponents {
	
	static func rentalPickedStatus (
		accountid: UUID,
		orderid: UUID,
        orderFolio: String,
		rentalid: UUID,
		ecoNumber: String,
		pickedUp: Bool,
		callback: @escaping ( (_ resp: APIResponse?) -> () )
	) {
		
		sendPost(
			rout,
			version,
			"rentalPickedStatus",
            RentalPickedStatusRequest(accountid: accountid, orderid: orderid, orderFolio: orderFolio, rentalid: rentalid, ecoNumber: ecoNumber, pickedUp: pickedUp)
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
