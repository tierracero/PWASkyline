//
//  CustAPI+SincStore.swift
//  
//
//  Created by Victor Cantu on 2/22/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustAPIEndpointV1 {
	
	static func sincStore( callback: @escaping ( (_ resp: APIResponseGeneric<SincStoreResponse>?) -> () )) {
		sendPost(
			rout,
			version,
			"sincStore",
			EmptyPayload()
		) { payload in
			guard let data = payload else{
				callback(nil)
				return
			}
			do{
				let resp = try JSONDecoder().decode(APIResponseGeneric<SincStoreResponse>.self, from: data)
				callback(resp)
			}
			catch{
				callback(nil)
			}
		}
	}
}
