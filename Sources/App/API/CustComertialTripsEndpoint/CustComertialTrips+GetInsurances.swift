import Foundation
import TCFundamentals
import TCFireSignal
import SkylineDocumentationCore

extension CustCommercialTripsComponents {
    
    static func getInsurances(
        callback: @escaping ((_ resp: APIResponseGeneric<GetInsurancesResponse>?) -> ())
    ) {
        sendPost(
            rout,
            version,
            "getInsurances",
            EmptyPayload()
        ) { data in
            
            guard let data else {
                callback(nil)
                return
            }
            
            do {
                callback(try decodeAPIResponse(APIResponseGeneric<GetInsurancesResponse>.self, from: data))
            }
            catch {
                callback(nil)
            }
        }
    }
}
