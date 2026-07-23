import Foundation
import TCFundamentals
import TCFireSignal
import SkylineDocumentationCore

extension CustCommercialTripsComponents {
    
    static func updateTrailer(
        trailerId: UUID,
        trailerType: String,
        trailerTypeName: String,
        trailerLicensePlate: String,
        callback: @escaping ((_ resp: APIResponse?) -> ())
    ) {
        sendPost(
            rout,
            version,
            "updateTrailer",
            UpdateTrailerRequest(
                trailerId: trailerId,
                trailerType: trailerType,
                trailerTypeName: trailerTypeName,
                trailerLicensePlate: trailerLicensePlate
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
