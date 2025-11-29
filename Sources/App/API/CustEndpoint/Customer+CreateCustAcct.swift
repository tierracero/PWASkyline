//
//  Customer+CreateCustAcct.swift
//
//
//  Created by Victor Cantu on 3/2/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustComponents {
    static func createCustAcct(
        CardID: String,
        firstName: String,
        secondName: String,
        lastName: String,
        secondLastName: String,
        email: String,
        mobile: String,
        telephone: String,
        birthDay: Int?,
        birthMonth: Int?,
        birthYear: Int?,
        sexo: Genders?,
        IDType: IdentificationTypes?,
        IDNum: String,
        type: CustAcctTypes,
        costType: CustAcctCostTypes,
        isConcessionaire: Bool,
        
        contacto1: String,
        contacto2: String,
        contactTel: String,
        contactMail: String,
        
        fiscalPOCFirstName: String,
        fiscalPOCLastName: String,
        fiscalPOCMobile: String,
        fiscalPOCMail: String,
        
        businessName: String,
        fiscalRecipt: Bool,
        fiscalRazon: String,
        fiscalRfc: String,
        street: String,
        colony: String,
        city: String,
        state: String,
        country: String,
        zip: String,
        mailStreet: String,
        mailColony: String,
        mailCity: String,
        mailState: String,
        mailCountry: String,
        mailZip: String,
        mobileIsValidated: Bool,
        idIsValidated: Bool,
        billDate: Int?,
        callback: @escaping ( (_ resp: APIResponseGeneric<CreateCustAcctResponse>?) -> () )) {
            
        sendPost(
            rout,
            version,
            "createCustAcct",
            CreateCustAcctRequest(
                storeid: custCatchStore,
                CardID: CardID,
                firstName: firstName,
                secondName: secondName,
                lastName: lastName,
                secondLastName: secondLastName,
                email: email,
                mobile: mobile,
                telephone: telephone,
                birthDay: birthDay,
                birthMonth: birthMonth,
                birthYear: birthYear,
                sexo: sexo,
                IDType: IDType,
                IDNum: IDNum,
                type: type,
                costType: costType,
                isConcessionaire: isConcessionaire,
                
                contacto1: contacto1,
                contacto2: contacto2,
                contactTel: contactTel,
                contactMail: contactMail,
                
                fiscalPOCFirstName: fiscalPOCFirstName,
                fiscalPOCLastName: fiscalPOCLastName,
                fiscalPOCMobile: fiscalPOCMobile,
                fiscalPOCMail: fiscalPOCMail,
                
                businessName: businessName,
                fiscalRecipt:  fiscalRecipt,
                fiscalRazon: fiscalRazon,
                fiscalRfc: fiscalRfc,
                
                street: street,
                colony: colony,
                city: city,
                state: state,
                country: country,
                zip: zip,
                
                mailStreet: mailStreet,
                mailColony: mailColony,
                mailCity: mailCity,
                mailState: mailState,
                mailCountry: mailCountry,
                mailZip: mailZip,
                mobileIsValidated: mobileIsValidated,
                idIsValidated: idIsValidated,
                billDate: billDate
            )
        ) { payload in
            guard let data = payload else{
                callback(nil)
                return
            }
            
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<CreateCustAcctResponse>.self, from: data)
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
