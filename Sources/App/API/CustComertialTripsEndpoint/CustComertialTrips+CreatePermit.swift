import Foundation
import TCFundamentals
import TCFireSignal
import SkylineDocumentationCore

extension CustCommercialTripsComponents {
    
    static func createPermit(
        permitType: TipoPermiso,
        permitTypeName: String,
        permitNumber: String,
        callback: @escaping ((_ resp: APIResponseGeneric<CreatePermitResponse>?) -> ())
    ) {
        sendPost(
            rout,
            version,
            "createPermit",
            CreatePermitRequest(
                permitType: permitType,
                permitTypeName: permitTypeName,
                permitNumber: permitNumber
            )
        ) { data in
            
            guard let data else {
                callback(nil)
                return
            }
            
            do {
                callback(try decodeAPIResponse(APIResponseGeneric<CreatePermitResponse>.self, from: data))
            }
            catch {
                callback(nil)
            }
        }
    }
}
