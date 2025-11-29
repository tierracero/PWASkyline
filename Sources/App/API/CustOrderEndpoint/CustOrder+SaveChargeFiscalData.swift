//
//  CustOrder+SaveChargeFiscalData.swift
//  
//
//  Created by Victor Cantu on 3/17/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustOrderComponents {
    
    static func saveChargeFiscalData (
        type: UpdateFiscalCodeType,
        id: UUID,
        code: String,
        callback: @escaping ( (_ resp: APIResponse?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "saveChargeFiscalData",
            SaveChargeFiscalDataRequest(
                type: type,
                id: id,
                code: code
            )
        ) { data in
            
            guard let data else{
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

