import Foundation
import TCFundamentals
import TCFireSignal
import SkylineDocumentationCore

extension CustCommercialTripsComponents {

    static func changeTripStatus(
        tripId: UUID,
        status: FiscalTripFollowupStatus,
        comment: String,
        media: [ChangeTripStatusMedia],
        callback: @escaping ((_ resp: APIResponse?) -> ())
    ) {
        sendPost(
            rout,
            version,
            "changeTripStatus",
            ChangeTripStatusRequest(
                tripId: tripId,
                status: status,
                comment: comment,
                media: media
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
