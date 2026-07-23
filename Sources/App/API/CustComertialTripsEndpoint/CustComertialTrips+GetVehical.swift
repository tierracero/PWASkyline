import Foundation
import TCFundamentals
import TCFireSignal
import SkylineDocumentationCore

extension CustCommercialTripsComponents {
    
    static func getVehical(
        vehicalId: UUID,
        callback: @escaping ((_ resp: APIResponseGeneric<GetVehicalResponse>?) -> ())
    ) {
        sendPost(
            rout,
            version,
            "getVehical",
            GetVehicalRequest(vehicalId: vehicalId)
        ) { data in
            
            guard let data else {
                callback(nil)
                return
            }
            
            do {
                callback(try decodeAPIResponse(APIResponseGeneric<GetVehicalResponse>.self, from: data))
            }
            catch {
                callback(nil)
            }
        }
    }
}
