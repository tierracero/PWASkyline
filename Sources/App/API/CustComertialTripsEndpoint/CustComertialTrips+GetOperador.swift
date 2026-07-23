import Foundation
import TCFundamentals
import TCFireSignal
import SkylineDocumentationCore

extension CustCommercialTripsComponents {
    
    static func getOperador(
        operadorId: UUID,
        callback: @escaping ((_ resp: APIResponseGeneric<GetOperadorResponse>?) -> ())
    ) {
        sendPost(
            rout,
            version,
            "getOperador",
            GetOperadorRequest(operadorId: operadorId)
        ) { data in
            
            guard let data else {
                callback(nil)
                return
            }
            
            do {
                callback(try decodeAPIResponse(APIResponseGeneric<GetOperadorResponse>.self, from: data))
            }
            catch {
                callback(nil)
            }
        }
    }
}
