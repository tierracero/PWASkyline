//
//  CustOrdeer+GetWorkLoadPayload.swift
//  
//
//  Created by Victor Cantu on 4/21/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustOrderComponents {
	
	///  Send OrderID to retive notes
	static func getWorkLoadPayload (
		id: UUID,
		callback: @escaping ( (_ resp: APIResponseGeneric<GetWorkLoadPayloadResponse>?) -> () )
	) {
		sendPost(
			rout,
			version,
			"getWorkLoadPayload",
			APIRequestID(id: id, store: nil)
		) { resp in
			guard let data = resp else {
				callback(nil)
				return
			}
			do{
				let resp = try JSONDecoder().decode(APIResponseGeneric<GetWorkLoadPayloadResponse>.self, from: data)
				callback(resp)
			}
			catch{
				callback(nil)
			}
		}
		
	}
}
