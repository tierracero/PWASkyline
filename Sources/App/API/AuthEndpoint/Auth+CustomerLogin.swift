//
//  Auth+CustomerLogin.swift
//  
//
//  Created by Victor Cantu on 2/16/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension AuthEndpointV1 {
	
	static func customerLogin(
        username: String,
        password: String,
        OS: String?,
        OSv: String?,
        model: String?,
        brand: String?,
        callback: @escaping ( (_ resp: APIResponseGeneric<CustomerLoginResponse>?) -> () )
    ) {
        
		sendPost(
			rout,
			version,
			"customerLogin",
            CustomerLoginRequest(
                username: username,
                password: password,
                AppID: "1000",
                secureAppBypassProtocol: "pleaseBypaseImAnApp",
                OS:  OS,
                OSv:  OSv,
                model: model,
                brand: brand,
                vcon: 1,
                tcon: .app
            )
		) { resp in
            
				guard let data = resp else{
					callback(nil)
					return
				}
			
				do{
					let resp = try JSONDecoder().decode(
                        APIResponseGeneric<CustomerLoginResponse>.self, from: data)
					
					callback(resp)
					
				}
				catch{
					
					print(error)
					
					callback(nil)
				}
			
			}
	}
}
