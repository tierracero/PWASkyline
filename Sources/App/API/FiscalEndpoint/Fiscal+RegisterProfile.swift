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
        sat_web_pass: String,
        nomComercial: String,
        /// 612 Personas Físicas con Actividades Empresariales y Profesionales...
        regimen: FiscalRegimens,
        zipCode: String,
        ///ingreso I, egreso E , nomina N, pago P, traslado T
        tipoDeFact: FiscalType,
        ///P01 porDefinir, G03 gastosEnGeneral, P01 porDefinir...
        usoDeFact: FiscalUse,
        tipoDePago: FiscalPaymentCodes,
        ///Ejemplo: efectivo, chequeNominativo, transferenciaElectronicaDeFondos ...
        methDePago: FiscalPaymentMeths,
        /// MXN, USD, EUR, CAD ...
        tipoDeMoneda: FIDocumentCurrency,
        fiscUnit: String,
        fiscCode: String,
        fiel_sat_cer: String,
        fiel_sat_key: String,
        fiel_sat_pass: String,
        /// azul, rojo, naranja, verde
        theme: FIColors,
        serie: String,
        folio: String,
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
                sat_web_pass: sat_web_pass,
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
                fiel_sat_cer: fiel_sat_cer,
                fiel_sat_key: fiel_sat_key,
                fiel_sat_pass: fiel_sat_pass,
                theme: theme,
                serie: serie,
                folio: folio,
                logo: logo
            )
        ) { payload in
            
            guard let data = payload else{
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
