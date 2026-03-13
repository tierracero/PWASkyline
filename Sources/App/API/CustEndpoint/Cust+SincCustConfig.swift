//
//  Cust+SincCustConfig.swift
//  
//
//  Created by Victor Cantu on 2/22/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustComponents {
	
	static func sincCustConfig( callback: @escaping ( (_ resp: APIResponseGeneric<SincCustConfigResponse>?) -> () )) {
		sendPost(
			rout,
			version,
			"sincCustConfig",
			EmptyPayload()
		) { data in
			guard let data else{
				callback(nil)
				return
			}
			do{
				let resp = try JSONDecoder().decode(APIResponseGeneric<SincCustConfigResponse>.self, from: data)
				callback(resp)
			}
			catch{

				print("🔴 errror")

				print(error)
				callback(nil)
			}
		}
	}
	
}
