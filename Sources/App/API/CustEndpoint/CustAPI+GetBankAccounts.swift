//
//  CustAPI+GetBankAccounts.swift
//  
//
//  Created by Victor Cantu on 2/22/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustComponents {
		
	static func getBankAccounts( callback: @escaping ( (_ resp: APIResponseGeneric<GetBankAccountsResponse>?) -> () )) {
		sendPost(
			rout,
			version,
			"getBankAccounts",
			EmptyPayload()
		) { payload in
			guard let data = payload else{
				callback(nil)
				return
			}
			do{
				let resp = try JSONDecoder().decode(APIResponseGeneric<GetBankAccountsResponse>.self, from: data)
				callback(resp)
			}
			catch{
				callback(nil)
			}
		}
	}
	
}
