//
//  CustPOC+GetManualDispertions.swift
//
//
//  Created by Victor Cantu on 12/14/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustPOCComponents {
    
    static func getManualDispertions(
        type: GetManualDispertionsType,
        callback: @escaping ( (_ resp: APIResponseGeneric<[GetManualDispertionsObject]>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "getManualDispertions",
            type
        ) { payload in
            guard let data = payload else{
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<[GetManualDispertionsObject]>.self, from: data)
                callback(resp)
            }
            catch{
                print(error)
                callback(nil)
            }
        }
    }
}
