import Foundation
import TCFundamentals
import TCFireSignal
import SkylineDocumentationCore

extension CustCommercialTripsComponents {
    
    static func getTrips(
        accountId: UUID?,
        type: GetTripsType,
        callback: @escaping ((_ resp: APIResponseGeneric<GetTripsResponse>?) -> ())
    ) {
        sendPost(
            rout,
            version,
            "getTrips",
            GetTripsRequest(
                accountId: accountId,
                type: type
            )
        ) { data in
            
            guard let data else {
                callback(nil)
                return
            }
            
            do {
                callback(try decodeAPIResponse(APIResponseGeneric<GetTripsResponse>.self, from: data))
            }
            catch {
                callback(nil)
            }
        }
    }
}
