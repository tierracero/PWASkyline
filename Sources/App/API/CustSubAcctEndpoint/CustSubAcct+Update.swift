import Foundation
import TCFundamentals
import TCFireSignal

extension CustSubAcctComponents {
    public static func update(
        id: UUID,
        type: CustAcctTypes,
        businessName: String,
        username: String,
        title: String,
        firstName: String,
        secondName: String,
        lastName: String,
        secondLastName: String,
        telephone: String,
        mobile: String,
        email: String,
        street: String,
        colony: String,
        city: String,
        state: String,
        country: String,
        zip: String,
        latitude: Double?,
        longitud: Double?,
        status: GeneralStatus,
        callback: @escaping (APIResponse?) -> Void
    ) {
        sendPost(rout, version, "update", UpdateRequest(
            id: id,
            type: type,
            businessName: businessName,
            username: username,
            title: title,
            firstName: firstName,
            secondName: secondName,
            lastName: lastName,
            secondLastName: secondLastName,
            telephone: telephone,
            mobile: mobile,
            email: email,
            street: street,
            colony: colony,
            city: city,
            state: state,
            country: country,
            zip: zip,
            latitude: latitude,
            longitud: longitud,
            status: status
        )) { data in
            guard let data else {
                callback(nil)
                return
            }

            do {
                callback(try decodeAPIResponse(APIResponse.self, from: data))
            } catch {
                callback(nil)
            }
        }
    }
}
