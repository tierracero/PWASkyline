import Foundation
import TCFundamentals
import TCFireSignal
import SkylineDocumentationCore

extension CustCommercialTripsComponents {
    
    static func getVehicals(
        callback: @escaping ((_ resp: APIResponseGeneric<GetVehicalsResponse>?) -> ())
    ) {
        sendPost(
            rout,
            version,
            "getVehicals",
            EmptyPayload()
        ) { data in
            
            guard let data else {
                callback(nil)
                return
            }
            
            do {
                callback(try decodeAPIResponse(APIResponseGeneric<GetVehicalsResponse>.self, from: data))
            }
            catch {
                callback(nil)
            }
        }
    }
}
