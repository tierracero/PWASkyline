//
//  CustPOC+GetPOCBodSec.swift
//  
//
//  Created by Victor Cantu on 9/28/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustPOCComponents {
    
    static func getPOCBodSec(
        pocid: UUID,
        storeid: UUID,
        callback: @escaping ( (_ resp: APIResponseGeneric<GetPOCBodSecResponse>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "getPOCBodSec",
            GetPOCBodSecRequest(
                pocid: pocid,
                storeid: storeid
            )
        ) { payload in
            guard let data = payload else{
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<GetPOCBodSecResponse>.self, from: data)
                callback(resp)
            }
            catch{
                print(error)
                callback(nil)
            }
        }
    }
}

