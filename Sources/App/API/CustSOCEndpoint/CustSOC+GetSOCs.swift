//
//  CustSOC+GetSOCs.swift
//  
//
//  Created by Victor Cantu on 3/31/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustSOCEndpointV1 {
    
    static func getSOCs(
        depid: UUID,
        callback: @escaping ( (_ resp: APIResponseGeneric<[CustSOCQuick]>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "getSOCs",
            GetSOCsRequest(
                depid: depid
            )
        ) { payload in
            
            guard let data = payload else{
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<[CustSOCQuick]>.self, from: data)
                callback(resp)
            }
            catch{
                print(error)
                callback(nil)
            }
        }
    }
}
