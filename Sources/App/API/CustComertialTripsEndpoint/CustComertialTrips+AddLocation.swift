import Foundation
import TCFundamentals
import TCFireSignal
import SkylineDocumentationCore

extension CustCommercialTripsComponents {
    
    static func addLocation(
        tripId: UUID,
        locationId: UUID,
        distance: Int64? = nil,
        callback: @escaping ((_ resp: APIResponseGeneric<AddLocationResponse>?) -> ())
    ) {
        sendPost(
            rout,
            version,
            "addLocation",
            AddLocationRequest(
                tripId: tripId,
                locationId: locationId,
                distance: distance
            )
        ) { data in
            
            guard let data else {
                callback(nil)
                return
            }
            
            do {
                callback(try decodeAPIResponse(APIResponseGeneric<AddLocationResponse>.self, from: data))
            }
            catch {
                callback(nil)
            }
        }
    }
}
