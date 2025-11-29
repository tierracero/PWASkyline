//
//  CustAccount+CreditRequest.swift
//
//
//  Created by Victor Cantu on 1/8/24.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustAccountComponents {
    
    public static func creditRequest(
        custAcct: UUID,
        requestType: CustAcctTypes,
        creditType: CustCreditType,
        eventType: CreateODS,
        downPayment: Float,
        intresRate: Float,
        creditLimit: Float,
        daysToPay: Float,
        billDate: Int?,
        yearsInCurrentWork: Float,
        yearsInCurrentHome: Float,
        totalIncome: Float,
        homeStatus: CustCreditCustomerHomeStatus,
        weeklySchedule: String,
        saturdaySchedule: String,
        sundaySchedule: String,
        workName: String,
        workPhone: String,
        workSupervisor: String,
        refrenceOneRelationType: CustCreditRefrenceType,
        refrenceOneNames: String,
        refrenceOneLastNames: String,
        refrenceOneTelephoneType: TelephoneType,
        refrenceOneTelephone: String,
        refrenceTwoRelationType: CustCreditRefrenceType,
        refrenceTwoNames: String,
        refrenceTwoLastNames: String,
        refrenceTwoTelephoneType: TelephoneType,
        refrenceTwoTelephone: String,
        refrenceThreeRelationType: CustCreditRefrenceType,
        refrenceThreeNames: String,
        refrenceThreeLastNames: String,
        refrenceThreeTelephoneType: TelephoneType,
        refrenceThreeTelephone: String,
        idType: IdentificationTypes?,
        idFront: String,
        idBack: String,
        legalRepresentetive: String,
        callback: @escaping ( (_ resp: APIResponseGeneric<CreditResponse>?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "creditRequest",
            CreditRequest(
                custAcct: custAcct,
                requestType: requestType,
                creditType: creditType,
                eventType: eventType,
                downPayment: downPayment,
                intresRate: intresRate,
                creditLimit: creditLimit,
                daysToPay: daysToPay,
                billDate: billDate,
                yearsInCurrentWork: yearsInCurrentWork,
                yearsInCurrentHome: yearsInCurrentHome,
                totalIncome: totalIncome,
                homeStatus: homeStatus,
                weeklySchedule: weeklySchedule,
                saturdaySchedule: saturdaySchedule,
                sundaySchedule: sundaySchedule,
                workName: workName,
                workPhone: workPhone,
                workSupervisor: workSupervisor,
                refrenceOneRelationType: refrenceOneRelationType,
                refrenceOneNames: refrenceOneNames,
                refrenceOneLastNames: refrenceOneLastNames,
                refrenceOneTelephoneType: refrenceOneTelephoneType,
                refrenceOneTelephone: refrenceOneTelephone,
                refrenceTwoRelationType: refrenceTwoRelationType,
                refrenceTwoNames: refrenceTwoNames,
                refrenceTwoLastNames: refrenceTwoLastNames,
                refrenceTwoTelephoneType: refrenceTwoTelephoneType,
                refrenceTwoTelephone: refrenceTwoTelephone,
                refrenceThreeRelationType: refrenceThreeRelationType,
                refrenceThreeNames: refrenceThreeNames,
                refrenceThreeLastNames: refrenceThreeLastNames,
                refrenceThreeTelephoneType: refrenceThreeTelephoneType,
                refrenceThreeTelephone: refrenceThreeTelephone,
                idType: idType,
                idFront: idFront,
                idBack: idBack,
                legalRepresentetive: legalRepresentetive
            )
        ) { data in
            
            guard let data else{
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponseGeneric<CreditResponse>.self, from: data)
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
