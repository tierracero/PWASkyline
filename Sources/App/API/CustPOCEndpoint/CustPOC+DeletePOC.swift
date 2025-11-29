//
//  CustPOC+DeletePOC.swift
//
//
//  Created by Victor Cantu on 7/19/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustPOCComponents {
    
    static func deletePOC(
        id: UUID,
        pDir: String,
        callback: @escaping ( (_ resp: APIResponse?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "deletePOC",
            DeletePOCRequest(
                id: id,
                pDir: pDir
            )
        ) { payload in
            guard let data = payload else{
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponse.self, from: data)
                callback(resp)
            }
            catch{
                print(error)
                callback(nil)
            }
        }
    }
}
