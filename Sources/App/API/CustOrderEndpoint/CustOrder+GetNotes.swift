//
//  CustOrder+GetNotes.swift
//  
//
//  Created by Victor Cantu on 4/18/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustOrderEndpointV1 {
	
	///  Send OrderID to retive notes
	static func getNotes (
        accountId: UUID,
		callback: @escaping ( (_ resp: APIResponseGeneric<GetNotesResponse>?) -> () )
	) {
		
		sendPost(
			rout,
			version,
			"getNotes",
            GetNotesRequest(
                accountId: accountId
            )
		) { data in
            
			guard let data else {
				callback(nil)
				return
			}
            
			do{
				let resp = try JSONDecoder().decode(APIResponseGeneric<GetNotesResponse>.self, from: data)
				callback(resp)
			}
			catch{
				callback(nil)
			}
		}
		
	}
}
