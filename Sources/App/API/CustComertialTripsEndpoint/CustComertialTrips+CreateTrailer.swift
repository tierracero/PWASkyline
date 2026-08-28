import Foundation
import TCFundamentals
import TCFireSignal
import SkylineDocumentationCore

extension CustCommercialTripsComponents {
    
    static func createTrailer(
        trailerType: String,
        trailerTypeName: String,
        trailerLicensePlate: String,
        avatar: String? = nil,
        callback: @escaping ((_ resp: APIResponseGeneric<CreateTrailerResponse>?) -> ())
    ) {
        sendPost(
            rout,
            version,
            "createTrailer",
            CreateTrailerRequest(
                trailerType: trailerType,
                trailerTypeName: trailerTypeName,
                trailerLicensePlate: trailerLicensePlate,
                avatar: avatar
            )
        ) { data in
            
            guard let data else {
                callback(nil)
                return
            }
            
            do {
                callback(try decodeAPIResponse(APIResponseGeneric<CreateTrailerResponse>.self, from: data))
            }
            catch {
                callback(nil)
            }
        }
    }
}
