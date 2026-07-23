import Foundation
import TCFundamentals
import TCFireSignal
import SkylineDocumentationCore

extension CustCommercialTripsComponents {
    
    static func getLocation(
        locationId: UUID,
        callback: @escaping ((_ resp: APIResponseGeneric<GetLocationResponse>?) -> ())
    ) {
        sendPost(
            rout,
            version,
            "getLocation",
            GetLocationRequest(locationId: locationId)
        ) { data in
            
            guard let data else {
                callback(nil)
                return
            }
            
            do {
                callback(try decodeAPIResponse(APIResponseGeneric<GetLocationResponse>.self, from: data))
            }
            catch {
                callback(nil)
            }
        }
    }
}
