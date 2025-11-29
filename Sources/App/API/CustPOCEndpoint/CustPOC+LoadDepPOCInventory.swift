//
//  CustPOC+LoadDepPOCInventory.swift
//  
//
//  Created by Victor Cantu on 3/13/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustPOCComponents {
	
	static func loadDepPOCInventory(depid: UUID, storeid: UUID, uts: Int64, highPriority: Bool, callback: @escaping ( (_ resp: APIResponseGeneric<LoadDepPOCInventoryResponse>?) -> () )) {
		
		sendPost(
			rout,
			version,
			"loadDepPOCInventory",
			LoadDepPOCInventoryRequest(depid: depid, storeid: storeid, uts: uts, highPriority: highPriority)
		) { payload in
			guard let data = payload else{
				callback(nil)
				return
			}
			do{
				let resp = try JSONDecoder().decode(APIResponseGeneric<LoadDepPOCInventoryResponse>.self, from: data)
				callback(resp)
			}
			catch{
				print(error)
				callback(nil)
			}
		}
	}
}
