//
//  Fiscal+RegisterProfile.swift
//  
//
//  Created by Victor Cantu on 11/29/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension FiscalComponents {
    
    static func registerProfile(
        eMail: String,
        username: String,
        password: String,
        pack: String,
        rfc: String,
        razon: String,
        satPass: String,
        nomComercial: String,
        regimen: FiscalRegimens,
        zipCode: String,
        tipoDeFact: FiscalType,
        usoDeFact: FiscalUse,
        tipoDePago: FiscalPaymentCodes,
        methDePago: FiscalPaymentMeths,
        tipoDeMoneda: FIDocumentCurrency,
        fiscUnit: String,
        fiscCode: String,
        cerType: CerType,
        cerFile: String,
        keyFile: String,
        passFile: String,
        serie: String,
        folio: String,
        theme: FIColors,
        logo: String,
        callback: @escaping ( (_ resp: APIResponseGeneric<FiscalComponents.Profile>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "registerProfile",
            RegisterProfileRequest(
                eMail: eMail,
                username: username,
                password: password,
                pack: pack,
                rfc: rfc,
                razon: razon,
                satPass: satPass,
                nomComercial: nomComercial,
                regimen: regimen,
                zipCode: zipCode,
                tipoDeFact: tipoDeFact,
                usoDeFact: usoDeFact,
                tipoDePago: tipoDePago,
                methDePago: methDePago,
                tipoDeMoneda: tipoDeMoneda,
                fiscUnit: fiscUnit,
                fiscCode: fiscCode,
                cerType: cerType,
                cerFile: cerFile,
                keyFile: keyFile,
                passFile: passFile,
                serie: serie,
                folio: folio,
                theme: theme,
                logo: logo
            )
        ) { data in
            
            guard let data else {
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<FiscalComponents.Profile>.self, from: data)
                callback(resp)
            }
            catch{
                print(error)
                callback(nil)
            }
        }
        
    }
}
