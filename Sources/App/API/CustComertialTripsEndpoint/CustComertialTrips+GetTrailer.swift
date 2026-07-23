import Foundation
import TCFundamentals
import TCFireSignal
import SkylineDocumentationCore

extension CustCommercialTripsComponents {
    
    static func getTrailer(
        trailerId: UUID,
        callback: @escaping ((_ resp: APIResponseGeneric<GetTrailerResponse>?) -> ())
    ) {
        sendPost(
            rout,
            version,
            "getTrailer",
            GetTrailerRequest(trailerId: trailerId)
        ) { data in
            
            guard let data else {
                callback(nil)
                return
            }
            
            do {
                callback(try decodeAPIResponse(APIResponseGeneric<GetTrailerResponse>.self, from: data))
            }
            catch {
                callback(nil)
            }
        }
    }
}
