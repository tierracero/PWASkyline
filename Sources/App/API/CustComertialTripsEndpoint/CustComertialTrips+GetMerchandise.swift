import Foundation
import TCFundamentals
import TCFireSignal
import SkylineDocumentationCore

extension CustCommercialTripsComponents {
    
    static func getMerchandise(
        merchandiseId: UUID,
        callback: @escaping ((_ resp: APIResponseGeneric<GetMerchandiseResponse>?) -> ())
    ) {
        sendPost(
            rout,
            version,
            "getMerchandise",
            GetMerchandiseRequest(merchandiseId: merchandiseId)
        ) { data in
            
            guard let data else {
                callback(nil)
                return
            }
            
            do {
                callback(try decodeAPIResponse(APIResponseGeneric<GetMerchandiseResponse>.self, from: data))
            }
            catch {
                callback(nil)
            }
        }
    }
}
