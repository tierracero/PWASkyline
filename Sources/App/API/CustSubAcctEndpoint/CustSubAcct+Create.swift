import Foundation
import TCFundamentals
import TCFireSignal

extension CustSubAcctComponents {
    public static func create(
        custAcct: UUID,
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
        callback: @escaping (APIResponseGeneric<CreateResponse>?) -> Void
    ) {
        sendPost(rout, version, "create", CreateRequest(
            custAcct: custAcct,
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
            longitud: longitud
        )) { data in
            guard let data else {
                callback(nil)
                return
            }

            do {
                callback(try decodeAPIResponse(APIResponseGeneric<CreateResponse>.self, from: data))
            } catch {
                callback(nil)
            }
        }
    }
}
