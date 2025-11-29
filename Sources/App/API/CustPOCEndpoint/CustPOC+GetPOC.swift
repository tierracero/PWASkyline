//
//  CustPOC+GetPOC.swift
//  
//
//  Created by Victor Cantu on 1/30/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustPOCComponents {
    
    static func getPOC(
            id: UUID,
            full: Bool,
        callback: @escaping ( (_ resp: APIResponseGeneric<GetPOCReponse>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "getPOC",
            GetPOCRequest(
                id: id,
                full: full
            )
        ) { payload in
            guard let data = payload else{
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<GetPOCReponse>.self, from: data)
                callback(resp)
            }
            catch{
                print(error)
                callback(nil)
            }
        }
    }
}
