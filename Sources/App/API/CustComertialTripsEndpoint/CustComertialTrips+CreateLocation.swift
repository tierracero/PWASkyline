import Foundation
import TCFundamentals
import TCFireSignal
import SkylineDocumentationCore

extension CustCommercialTripsComponents {
    
    static func createLocation(
        placementType: TipoUbicacion,
        placementId: String,
        rfc: String,
        razon: String,
        uts: Int64,
        storeName: String,
        street: String,
        number: String,
        colonie: String,
        refrence: String,
        state: CountryStatesMexico,
        country: String,
        zipCode: String,
        callback: @escaping ((_ resp: APIResponseGeneric<CreateLocationResponse>?) -> ())
    ) {
        sendPost(
            rout,
            version,
            "createLocation",
            CreateLocationRequest(
                placementType: placementType,
                placementId: placementId,
                rfc: rfc,
                razon: razon,
                uts: uts,
                storeName: storeName,
                street: street,
                number: number,
                colonie: colonie,
                refrence: refrence,
                state: state,
                country: country,
                zipCode: zipCode
            )
        ) { data in
            
            guard let data else {
                callback(nil)
                return
            }
            
            do {
                callback(try decodeAPIResponse(APIResponseGeneric<CreateLocationResponse>.self, from: data))
            }
            catch {
                callback(nil)
            }
        }
    }
}
