import Foundation
import TCFundamentals
import TCFireSignal
import SkylineDocumentationCore

extension CustCommercialTripsComponents {
    
    static func getTrailers(
        callback: @escaping ((_ resp: APIResponseGeneric<GetTrailersResponse>?) -> ())
    ) {
        sendPost(
            rout,
            version,
            "getTrailers",
            EmptyPayload()
        ) { data in
            
            guard let data else {
                callback(nil)
                return
            }
            
            do {
                callback(try decodeAPIResponse(APIResponseGeneric<GetTrailersResponse>.self, from: data))
            }
            catch {
                callback(nil)
            }
        }
    }
}
