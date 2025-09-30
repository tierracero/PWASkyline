//
//  Cust+RequestPasswordRecoveryConfirmCellphone.swift
//  
//
//  Created by Victor Cantu on 8/25/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustAPIEndpointV1 {
        
    static func requestPasswordRecoveryConfirmCellphone(
        username: String,
        key: String,
        cell: String,
        callback: @escaping ( (_ resp: APIResponse?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "requestPasswordRecoveryConfirmCellphone",
            RequestPasswordRecoveryConfirmCellphoneRequest(
                username: username,
                key: key,
                cell: cell
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
                print("🔴 API_DECODING_ERROR")
                print(error)
                callback(nil)
            }
        }
    }
}
