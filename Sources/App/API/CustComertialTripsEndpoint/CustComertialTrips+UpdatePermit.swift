import Foundation
import TCFundamentals
import TCFireSignal
import SkylineDocumentationCore

extension CustCommercialTripsComponents {
    
    static func updatePermit(
        permitId: UUID,
        permitType: TipoPermiso,
        permitTypeName: String,
        permitNumber: String,
        permitName: String,
        callback: @escaping ((_ resp: APIResponse?) -> ())
    ) {
        sendPost(
            rout,
            version,
            "updatePermit",
            UpdatePermitRequest(
                permitId: permitId,
                permitType: permitType,
                permitTypeName: permitTypeName,
                permitNumber: permitNumber,
                permitName: permitName
            )
        ) { data in
            
            guard let data else {
                callback(nil)
                return
            }
            
            do {
                callback(try decodeAPIResponse(APIResponse.self, from: data))
            }
            catch {
                callback(nil)
            }
        }
    }
}
