import Foundation
import TCFundamentals
import TCFireSignal
import SkylineDocumentationCore

extension CustCommercialTripsComponents {
    
    static func components(
        callback: @escaping ((_ resp: APIResponseGeneric<ComponentsResponse>?) -> ())
    ) {
        sendPost(
            rout,
            version,
            "components",
            EmptyPayload()
        ) { data in
            
            guard let data else {
                callback(nil)
                return
            }
            
            do {
                callback(try decodeAPIResponse(APIResponseGeneric<ComponentsResponse>.self, from: data))
            }
            catch {
                callback(nil)
            }
        }
    }
}
