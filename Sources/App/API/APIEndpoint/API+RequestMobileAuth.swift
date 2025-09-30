//
//  API+RequestMobileAuth.swift
//  
//
//  Created by Victor Cantu on 3/1/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension APIEndpointV1 {
	
	
	static func requestMobileAuth( mobile: String, token: String, callback: @escaping ( (_ resp: APIResponse?) -> () ) ) {
		
		sendPost(
			rout,
			version,
			"requestMobileAuth",
			RequestMobileAuthRequest(
                mobile: mobile,
                token: token,
                isSecure: false
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
