import Foundation
import TCFundamentals
import TCFireSignal
import SkylineDocumentationCore

extension CustCommercialTripsComponents {
    
    static func getPermit(
        permitId: UUID,
        callback: @escaping ((_ resp: APIResponseGeneric<GetPermitResponse>?) -> ())
    ) {
        sendPost(
            rout,
            version,
            "getPermit",
            GetPermitRequest(permitId: permitId)
        ) { data in
            
            guard let data else {
                callback(nil)
                return
            }
            
            do {
                callback(try decodeAPIResponse(APIResponseGeneric<GetPermitResponse>.self, from: data))
            }
            catch {
                callback(nil)
            }
        }
    }
}
