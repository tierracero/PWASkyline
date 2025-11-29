//
//  Cust+WorkWithUsSaveGeneralData.swift
//  
//
//  Created by Victor Cantu on 6/5/23.
//

/*

import Foundation
import TCFundamentals
import TCFireSignal

extension CustComponents {
        
    public static func workWithUsSaveGeneralData(
        token: String,
        job: CustJobPost,
        profileid: UUID,
        subProfileid: UUID,
        givenTitle: String,
        firstName: String,
        secondName: String,
        lastName: String,
        secondLastName: String,
        cityOfBirth: String,
        stateOfBirth: String,
        countryOfBirth: String,
        birthDay: Int,
        birthMonth: Int,
        birthYear: Int,
        sexo: Genders,
        rfc: String,
        curp: String,
        nss: String,
        tcc: String,
        telephone: String,
        mcc: String,
        mobile: String,
        email: String,
        street: String,
        colony: String,
        city: String,
        state: String,
        country: String,
        zip: String,
        identification: IdentificationTypes,
        identificationNumber: String,
        residentialStatus: ResidentialStatus,
        civilStatus: CivilStatus,
        chronicDiseases: [String],
        activeSports: [String],
        hobbies: [String],
        lifeGoals: [String],
        syndicalism: Bool,
        canTravel: Bool,
        canChangeRecency: Bool,
        ownVehical: Bool,
        studies: Bool,
        perferdScheduleType: ScheduleType,
        employments: [EmploymentsQuick],
        refrences: [RefrencesQuick],
        educations: [EducationQuick],
        skills: [SkillsQuick],
        languges: [SkillsQuick],
        callback: @escaping ( (_ resp: APIResponse?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "workWithUsSaveGeneralData",
            WorkWithUsSaveGeneralDataRequest(
                token: token,
                job: job,
                profileid: profileid,
                subProfileid: subProfileid,
                givenTitle: givenTitle,
                firstName: firstName,
                secondName: secondName,
                lastName: lastName,
                secondLastName: secondLastName,
                cityOfBirth: cityOfBirth,
                stateOfBirth: stateOfBirth,
                countryOfBirth: countryOfBirth,
                birthDay: birthDay,
                birthMonth: birthMonth,
                birthYear: birthYear,
                sexo: sexo,
                rfc: rfc,
                curp: curp,
                nss: curp,
                tcc: tcc,
                telephone: telephone,
                mcc: mcc,
                mobile: mobile,
                email: email,
                street: street,
                colony: colony,
                city: city,
                state: state,
                country: country,
                zip: zip,
                identification: identification,
                identificationNumber: identificationNumber,
                residentialStatus: residentialStatus,
                civilStatus: civilStatus,
                chronicDiseases: chronicDiseases,
                activeSports: activeSports,
                hobbies: hobbies,
                lifeGoals: lifeGoals,
                syndicalism: syndicalism,
                canTravel: canTravel,
                canChangeRecency: canChangeRecency,
                ownVehical: ownVehical,
                studies: studies,
                perferdScheduleType: perferdScheduleType,
                employments: employments,
                refrences: refrences,
                educations: educations,
                skills: skills,
                languges: languges
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
*/
