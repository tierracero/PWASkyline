//
//  CustAccount+Update.swift
//  
//
//  Created by Victor Cantu on 1/4/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustAccountEndpointV1 {
    
    public static func update(
        id: UUID,
        custType: CustAcctTypes,
        thirdPartyService: Bool,
        isConcessionaire: Bool,
        sendOrderCommunication: Bool,
        costType: CustAcctCostTypes,
        businessName: String,
        ///If the CustAcct has multiple Fiscal Profile, determin wich will they pay with
        fiscalProfile: UUID?,
        fiscalProfileName: String,
        fiscalRazon: String,
        fiscalRfc: String,
        /// 612 Personas Físicas con Actividades Empresariales y Profesionales...
        fiscalRegime: FiscalRegimens?,
        fiscalZip: String,
        ///P01 porDefinir, G03 gastosEnGeneral, P01 porDefinir...
        fiscalPOCFirstName: String,
        fiscalPOCLastName: String,
        fiscalPOCMail: String,
        fiscalPOCMobile: String,
        cfdiUse: FiscalUse?,
        firstName: String,
        secondName: String,
        lastName: String,
        secondLastName: String,
        birthDay: Int?,
        birthMonth: Int?,
        birthYear: Int?,
        curp: String,
        telephone: String,
        telephone2: String,
        email: String,
        email2: String,
        mobile: String,
        mobile2: String,
        contacto1: String,
        contacto2: String,
        contactTel: String,
        street: String,
        colony: String,
        city: String,
        zip: String,
        state: String,
        country: String,
        mailStreet: String,
        mailColony: String,
        mailCity: String,
        mailZip: String,
        mailState: String,
        mailCountry: String,
        IDType: IdentificationTypes?,
        IDNum: String,
        sexo: Genders?,
        callback: @escaping ( (_ resp: APIResponse?) -> () )) {
        
        sendPost(
            rout,
            version,
            "update",
            UpdateRequest(
                id: id,
                custType: custType,
                thirdPartyService: thirdPartyService,
                isConcessionaire: isConcessionaire,
                sendOrderCommunication: sendOrderCommunication,
                costType: costType,
                businessName: businessName,
                ///If the CustAcct has multiple Fiscal Profile, determin wich will they pay with
                fiscalProfile: fiscalProfile,
                fiscalProfileName: fiscalProfileName,
                fiscalRazon: fiscalRazon,
                fiscalRfc: fiscalRfc,
                /// 612 Personas Físicas con Actividades Empresariales y Profesionales...
                fiscalRegime: fiscalRegime,
                fiscalZip: fiscalZip,
                ///P01 porDefinir, G03 gastosEnGeneral, P01 porDefinir...
                fiscalPOCFirstName: fiscalPOCFirstName,
                fiscalPOCLastName: fiscalPOCLastName,
                fiscalPOCMail: fiscalPOCMail,
                fiscalPOCMobile: fiscalPOCMobile,
                cfdiUse: cfdiUse,
                firstName: firstName,
                secondName: secondName,
                lastName: lastName,
                secondLastName: secondLastName,
                birthDay: birthDay,
                birthMonth: birthMonth,
                birthYear: birthYear,
                curp: curp,
                telephone: telephone,
                telephone2: telephone2,
                email: email,
                email2: email2,
                mobile: mobile,
                mobile2: mobile2,
                contacto1: contacto1,
                contacto2: contacto2,
                contactTel: contactTel,
                street: street,
                colony: colony,
                city: city,
                zip: zip,
                state: state,
                country: country,
                mailStreet: mailStreet,
                mailColony: mailColony,
                mailCity: mailCity,
                mailZip: mailZip,
                mailState: mailState,
                mailCountry: mailCountry,
                IDType: IDType,
                IDNum: IDNum,
                sexo: sexo
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
                print("⭕️ load \(#function)")
                print(error)
                callback(nil)
            }
        }
    }
}


