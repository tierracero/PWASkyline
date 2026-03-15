//
//  CustOrder+ExtractData.swift
//  SkylineServer
//
//  Created by Victor Cantu on 3/11/26.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustOrderComponents {

	static func extractData (
        fileName: String,
        scriptId: UUID,
		callback: @escaping ( (_ resp: APIResponseGeneric<ExtractDataResponse>?) -> () )
	) {
		
		sendPost(
			rout,
			version,
			"extractData",
            ExtractDataRequest(
                fileName: fileName,
                scriptId: scriptId
            )
		) { data in
			guard let data else {
				callback(nil)
				return
			}
			do {
				callback(try JSONDecoder().decode(APIResponseGeneric<ExtractDataResponse>.self, from: data))
			}
			catch{
				callback(nil)
			}
		}
		
	}
}
