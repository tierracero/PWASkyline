//
//  CustSOC+GetSOC.swift
//  
//
//  Created by Victor Cantu on 3/31/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustSOCEndpointV1 {
    
    static func getSOC(
        socid: UUID,
        callback: @escaping ( (_ resp: APIResponseGeneric<GetSOCResponse>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "getSOC",
            GetSOCRequest(
                socid: socid
            )
        ) { payload in
            
            guard let data = payload else{
                callback(nil)
                return
            }
            
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<GetSOCResponse>.self, from: data)
                callback(resp)
            }
            catch{
                print(error)
                callback(nil)
            }
        }
    }
}
