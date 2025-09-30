//
//  CustOrder+LoadFolio.swift
//  
//
//  Created by Victor Cantu on 4/16/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustOrderEndpointV1 {
	static func loadFolio (
		identifier: HybridIdentifier,
		callback: @escaping ( (_ resp: APIResponseGeneric<LoadFolioResponse>?) -> () )
	) {
		
		sendPost(
			rout,
			version,
			"loadFolio",
            LoadFolioRequest(identifier: identifier)
		) { resp in
			guard let data = resp else {
				callback(nil)
				return
			}
			do{
				let resp = try JSONDecoder().decode(APIResponseGeneric<LoadFolioResponse>.self, from: data)
				callback(resp)
			}
			catch{
                print(error)
				callback(nil)
			}
		}
		
	}
}
