import Foundation
import TCFundamentals
import TCFireSignal
import SkylineDocumentationCore

extension CustCommercialTripsComponents {
    
    static func addMercancia(
        tripId: UUID,
        mercanciaId: UUID,
        from: String,
        fromStoreName: String,
        to: String,
        toStoreName: String,
        callback: @escaping ((_ resp: APIResponseGeneric<AddMercanciaResponse>?) -> ())
    ) {
        sendPost(
            rout,
            version,
            "addMercancia",
            AddMercanciaRequest(
                tripId: tripId,
                mercanciaId: mercanciaId,
                from: from,
                fromStoreName: fromStoreName,
                to: to,
                toStoreName: toStoreName
            )
        ) { data in
            
            guard let data else {
                callback(nil)
                return
            }
            
            do {
                callback(try decodeAPIResponse(APIResponseGeneric<AddMercanciaResponse>.self, from: data))
            }
            catch {
                callback(nil)
            }
        }
    }
}
