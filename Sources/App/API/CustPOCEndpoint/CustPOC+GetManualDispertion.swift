//
//  CustPOC+GetManualDispertion.swift
//
//
//  Created by Victor Cantu on 12/14/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustPOCEndpointV1 {
    
    static func getManualDispertion(
        docId: HybridIdentifier,
        callback: @escaping ( (_ resp: APIResponseGeneric<GetManualDispertionResponse>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "getManualDispertion",
            GetManualDispertionRequest(
                docId: docId
            )
        ) { payload in
            guard let data = payload else{
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<GetManualDispertionResponse>.self, from: data)
                callback(resp)
            }
            catch{
                print(error)
                callback(nil)
            }
        }
    }
}
