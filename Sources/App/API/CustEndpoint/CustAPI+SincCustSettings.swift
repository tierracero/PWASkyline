//
//  CustAPI+SincCustSettings.swift
//  
//
//  Created by Victor Cantu on 2/22/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustComponents {
	
	static func sincCustSettings( callback: @escaping ( (_ resp: APIResponseGeneric<SincCustSettingsResponse>?) -> () )) {
		sendPost(
			rout,
			version,
			"sincCustSettings",
			EmptyPayload()
		) { data in
			guard let data  else{
				callback(nil)
				return
			}
			do{
				let resp = try JSONDecoder().decode(APIResponseGeneric<SincCustSettingsResponse>.self, from: data)
				callback(resp)
			}
			catch{

				print("🔴. errror")

				print(error)
				callback(nil)
			}
		}
	}
	
}
