//
//  CustPOC+CreateManualDispertion.swift
//
//
//  Created by Victor Cantu on 12/14/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustPOCComponents {
    
    static func createManualDispertion(
        name: String,
        store: UUID,
        fiscalProfile: UUID,
        vendor: UUID,
        callback: @escaping ( (_ resp: APIResponseGeneric<GetManualDispertionResponse>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "createManualDispertion",
            CreateManualDispertionRequest(
                name: name,
                store: store,
                fiscalProfile: fiscalProfile,
                vendor: vendor
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
