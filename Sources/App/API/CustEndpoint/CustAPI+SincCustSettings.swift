//
//  CustAPI+SincCustSettings.swift
//  
//
//  Created by Victor Cantu on 2/22/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustAPIEndpointV1 {
	

	static func sincCustSettings( callback: @escaping ( (_ resp: APIResponseGeneric<SincCustSettingsResponse>?) -> () )) {
		sendPost(
			rout,
			version,
			"sincCustSettings",
			EmptyPayload()
		) { payload in
			guard let data = payload else{
				callback(nil)
				return
			}
			do{
				let resp = try JSONDecoder().decode(APIResponseGeneric<SincCustSettingsResponse>.self, from: data)
				callback(resp)
			}
			catch{
				callback(nil)
			}
		}
	}
	
}
