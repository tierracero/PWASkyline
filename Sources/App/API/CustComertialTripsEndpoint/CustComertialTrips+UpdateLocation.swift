import Foundation
import TCFundamentals
import TCFireSignal
import SkylineDocumentationCore

extension CustCommercialTripsComponents {
    
    static func updateLocation(
        id: UUID,
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
        callback: @escaping ((_ resp: APIResponse?) -> ())
    ) {
        sendPost(
            rout,
            version,
            "updateLocation",
            UpdateLocationRequest(
                id: id,
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
                callback(try decodeAPIResponse(APIResponse.self, from: data))
            }
            catch {
                callback(nil)
            }
        }
    }
}
