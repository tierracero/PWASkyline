import Foundation
import TCFundamentals
import TCFireSignal
import SkylineDocumentationCore

extension CustCommercialTripsComponents {
    
    static func getMerchandises(
        callback: @escaping ((_ resp: APIResponseGeneric<GetMerchandisesResponse>?) -> ())
    ) {
        sendPost(
            rout,
            version,
            "getMerchandises",
            EmptyPayload()
        ) { data in
            
            guard let data else {
                callback(nil)
                return
            }
            
            do {
                callback(try decodeAPIResponse(APIResponseGeneric<GetMerchandisesResponse>.self, from: data))
            }
            catch {
                callback(nil)
            }
        }
    }
}
