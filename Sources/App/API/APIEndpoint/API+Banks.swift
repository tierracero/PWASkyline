//
//  API+Banks.swift
//  
//
//  Created by Victor Cantu on 2/23/22.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

extension APIEndpointV1 {
	
	static func getBanks( callback: @escaping ( (_ resp: [BanksItem]?) -> () )) {
		
//		if !Webbanks.isEmpty {
//			callback(Webbanks)
//			return
//		}
		
        if !banks.isEmpty {
            callback(banks)
            return
        }
        
        
		sendPost(
			rout,
			version,
			"banks",
			EmptyPayload()
		) { resp in
			guard let data = resp else{
				callback(nil)
				return
			}
			do{
				let resp = try JSONDecoder().decode([BanksItem].self, from: data)
                
                banks = resp
                
				callback(resp)
			}
			catch{
				callback(nil)
			}
		}
	}
	
}
