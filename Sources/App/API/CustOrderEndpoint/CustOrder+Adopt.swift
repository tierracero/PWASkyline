//
//  CustOrder+Adopt.swift
//  
//
//  Created by Victor Cantu on 4/24/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustOrderEndpointV1 {
	
	static func adopt (
		id: UUID,
		callback: @escaping ( (_ resp: APIResponseGeneric<AdoptResponse>?) -> () )
	) {
		
		sendPost(
			rout,
			version,
			"adopt",
			APIRequestID(id: id, store: nil)
		) { resp in
			guard let data = resp else{
				callback(nil)
				return
			}
			do{
				let resp = try JSONDecoder().decode(APIResponseGeneric<AdoptResponse>.self, from: data)
				callback(resp)
			}
			catch{
				callback(nil)
			}
		}
	}
}
