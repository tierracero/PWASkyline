//
//  CustSOC+UpdateFiscalCodes.swift
//  
//
//  Created by Victor Cantu on 3/17/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustSOCComponents {
    
    static func updateFiscalCodes(
        id: UUID,
        type: UpdateFiscalCodeType,
        code: String,
        callback: @escaping ( (_ resp: APIResponse?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "updateFiscalCodes",
            UpdateFiscalCodesRequest(
                id: id,
                type: type,
                code: code
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
