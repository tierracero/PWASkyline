//
//  CustUsername+Update.swift
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustUsernameComponents {

    static func update(
        id: UUID,
        password: String,
        pin: String,
        herk: Int,
        firstName: String,
        secondName: String,
        lastName: String,
        secondLastName: String,
        sexo: Genders,
        mobile: String,
        email: String,
        birthDay: Int,
        birthMonth: Int,
        birthYear: Int,
        nick: String,
        inicioDeTurno: String,
        finDeTurno: String,
        dayOfService: [Int],
        backGround: String,
        profile: [PanelConfigurationObjects],
        callback: @escaping ((_ resp: APIResponse?) -> ())
    ) {
        sendPost(
            rout,
            version,
            "update",
            UpdateRequest(
                id: id,
                password: password,
                pin: pin,
                herk: herk,
                firstName: firstName,
                secondName: secondName,
                lastName: lastName,
                secondLastName: secondLastName,
                sexo: sexo,
                mobile: mobile,
                email: email,
                birthDay: birthDay,
                birthMonth: birthMonth,
                birthYear: birthYear,
                nick: nick,
                inicioDeTurno: inicioDeTurno,
                finDeTurno: finDeTurno,
                dayOfService: dayOfService,
                backGround: backGround,
                profile: profile
            )
        ) { data in
            guard let data else {
                callback(nil)
                return
            }

            do {
                callback(try decodeAPIResponse(APIResponse.self, from: data))
            } catch {
                print("🔴 API_DECODING_ERROR")
                print(error)
                callback(nil)
            }
        }
    }
}
