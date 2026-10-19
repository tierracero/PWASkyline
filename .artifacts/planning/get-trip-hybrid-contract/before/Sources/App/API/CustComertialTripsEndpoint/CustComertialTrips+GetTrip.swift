import Foundation
import TCFundamentals
import TCFireSignal
import SkylineDocumentationCore

extension CustCommercialTripsComponents {
    
    static func getTrip(
        tripId: UUID,
        callback: @escaping ((_ resp: APIResponseGeneric<GetTripResponse>?) -> ())
    ) {
        sendPost(
            rout,
            version,
            "getTrip",
            GetTripRequest(tripId: tripId)
        ) { data in
            
            guard let data else {
                callback(nil)
                return
            }
            
            do {
                callback(try decodeAPIResponse(APIResponseGeneric<GetTripResponse>.self, from: data))
            }
            catch {
                callback(nil)
            }
        }
    }
}
