//
//  CustAccount+UpdateFiscal.swift
//  
//
//  Created by Victor Cantu on 2/7/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustAccountComponents {
    
    public static func updateFiscal(
        accountid: UUID,
        fiscalRazon: String,
        fiscalRfc: String,
        /// 612 Personas Físicas con Actividades Empresariales y Profesionales...
        fiscalRegime: FiscalRegimens,
        fiscalZip: String,
        fiscalPOCMail: String,
        fiscalPOCMobile: String,
        callback: @escaping ( (_ resp: APIResponse?) -> () )) {
        
        sendPost(
            rout,
            version,
            "updateFiscal",
            UpdateFiscalRequest(
                accountid: accountid,
                fiscalRazon: fiscalRazon,
                fiscalRfc: fiscalRfc,
                /// 612 Personas Físicas con Actividades Empresariales y Profesionales...
                fiscalRegime: fiscalRegime,
                fiscalZip: fiscalZip,
                fiscalPOCMail: fiscalPOCMail,
                fiscalPOCMobile: fiscalPOCMobile

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
                print("⭕️ loadDetails \(#function)")
                print(error)
                callback(nil)
            }
        }
    }
}


