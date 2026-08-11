//
//  CustUsername+Create.swift
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustUsernameComponents {

    static func create(
        id: UUID? = nil,
        ie: String? = nil,
        sitio: String? = nil,
        store: UUID,
        storeName: String,
        groop: UUID,
        groopSupervisor: UUID,
        groopName: String,
        username: String,
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
        bday: String,
        avatar: String,
        nick: String,
        activeEmail: Bool,
        mailStorage: Int,
        inicioDeTurno: String,
        finDeTurno: String,
        dayOfService: [Int],
        backGround: String,
        profile: [PanelConfigurationObjects],
        role: UsernameRoles? = nil,
        callback: @escaping ((_ resp: APIResponse?) -> ())
    ) {
        sendPost(
            rout,
            version,
            "create",
            CreateRequest(
                id: id,
                ie: ie,
                sitio: sitio,
                store: store,
                storeName: storeName,
                groop: groop,
                groopSupervisor: groopSupervisor,
                groopName: groopName,
                username: username,
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
                bday: bday,
                avatar: avatar,
                nick: nick,
                activeEmail: activeEmail,
                mailStorage: mailStorage,
                inicioDeTurno: inicioDeTurno,
                finDeTurno: finDeTurno,
                dayOfService: dayOfService,
                backGround: backGround,
                profile: profile,
                role: role
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
