//
//  CustAPI+GetUserRefrence.swift
//  
//
//  Created by Victor Cantu on 2/22/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustComponents {
	
	static func getUserRefrence( id: HybridIdentifier?, callback: @escaping ( (_ resp: APIResponseGeneric<GetUserRefrenceResponse>?) -> () )) {
		sendPost(
			rout,
			version,
			"getUserRefrence",
            GetUserRefrenceRequest(id: id)
		) { payload in
            
			guard let data = payload else{
				callback(nil)
				return
			}
            
			do{
				let resp = try JSONDecoder().decode(APIResponseGeneric<GetUserRefrenceResponse>.self, from: data)
				callback(resp)
			}
			catch{
                print("getUserRefrence")
                print(error)
                
				callback(nil)
			}
		}
	}
}
