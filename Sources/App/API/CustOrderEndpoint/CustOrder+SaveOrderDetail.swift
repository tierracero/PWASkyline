//
//   CustOrder+SaveOrderDetail.swift
//  
//
//  Created by Victor Cantu on 5/3/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustOrderEndpointV1 {
	
	static func saveOrderDetail (
		orderid: UUID,
		name: String,
		mobile: String,
		telephone: String,
		email: String,
		street: String,
		colony: String,
		city: String,
		state: String,
		country: String,
		zip: String,
		callback: @escaping ( (_ resp: APIResponse?) -> () )
	) {
		sendPost(
			rout,
			version,
			"saveOrderDetail",
			SaveOrderDetailRequest(orderid: orderid, name: name, mobile: mobile, telephone: telephone, email: email, street: street, colony: colony, city: city, state: state, country: country, zip: zip)
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
