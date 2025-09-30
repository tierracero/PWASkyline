//
//  CustOrder+LoadFolios.swift
//  
//
//  Created by Victor Cantu on 3/22/22.
//

import Foundation
import TCFundamentals
import TCFireSignal
import TCFundamentals

extension CustOrderEndpointV1 {
	
	static func loadFolios (
        storeid: UUID?,
		accountid: HybridIdentifier?,
		current: [APIStoreSincObject],
		curTrans: [APIStoreSincObject],
		callback: @escaping ( (_ resp: APIResponseGeneric<LoadFoliosResponse>?) -> () )
	) {
		
		sendPost(
			rout,
			version,
			"loadFolios",
			LoadFoliosRequest(
                storeid: storeid,
                accountid: accountid,
                current: current,
                curTrans: curTrans
            )
		) { resp in
			guard let data = resp else{
				callback(nil)
				return
			}
			do{
				let resp = try JSONDecoder().decode(APIResponseGeneric<LoadFoliosResponse>.self, from: data)
				callback(resp)
			}
			catch{
				callback(nil)
			}
		}
		
	}
	
}
