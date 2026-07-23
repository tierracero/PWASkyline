import Foundation
import TCFundamentals
import TCFireSignal
import SkylineDocumentationCore

extension CustCommercialTripsComponents {
    
    static func getOperadors(
        callback: @escaping ((_ resp: APIResponseGeneric<GetOperadorsResponse>?) -> ())
    ) {
        sendPost(
            rout,
            version,
            "getOperadors",
            EmptyPayload()
        ) { data in
            
            guard let data else {
                callback(nil)
                return
            }
            
            do {
                callback(try decodeAPIResponse(APIResponseGeneric<GetOperadorsResponse>.self, from: data))
            }
            catch {
                callback(nil)
            }
        }
    }
}
