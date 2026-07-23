import Foundation
import TCFundamentals
import TCFireSignal
import SkylineDocumentationCore

extension CustCommercialTripsComponents {
    
    static func getLocations(
        callback: @escaping ((_ resp: APIResponseGeneric<GetLocationsResponse>?) -> ())
    ) {
        sendPost(
            rout,
            version,
            "getLocations",
            EmptyPayload()
        ) { data in
            
            guard let data else {
                callback(nil)
                return
            }
            
            do {
                callback(try decodeAPIResponse(APIResponseGeneric<GetLocationsResponse>.self, from: data))
            }
            catch {
                callback(nil)
            }
        }
    }
}
