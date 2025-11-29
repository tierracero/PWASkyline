//
//  API+ConfirmMobileAuth.swift
//  
//
//  Created by Victor Cantu on 3/2/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension APIComponents {
	

	static func confirmMobileAuth(
        token: String,
        pin: String,
        callback: @escaping ( (_ resp: APIResponse?) -> () )
	) {
		
		sendPost(
			rout,
			version,
			"confirmMobileAuth",
            ConfirmMobileAuthRequest(
                token: token,
                pin: pin
            )
		) { resp in
			guard let data = resp else{
				callback(nil)
				return
			}
			do{
				let resp = try JSONDecoder().decode(APIResponse.self, from: data)
				callback(resp)
			}
			catch{
				callback(nil)
			}
		}
	}
}
