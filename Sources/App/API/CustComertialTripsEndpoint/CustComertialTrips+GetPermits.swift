import Foundation
import TCFundamentals
import TCFireSignal
import SkylineDocumentationCore

extension CustCommercialTripsComponents {
    
    static func getPermits(
        callback: @escaping ((_ resp: APIResponseGeneric<GetPermitsResponse>?) -> ())
    ) {
        sendPost(
            rout,
            version,
            "getPermits",
            EmptyPayload()
        ) { data in
            
            guard let data else {
                callback(nil)
                return
            }
            
            do {
                callback(try decodeAPIResponse(APIResponseGeneric<GetPermitsResponse>.self, from: data))
            }
            catch {
                callback(nil)
            }
        }
    }
}
