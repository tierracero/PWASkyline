import Foundation
import TCFundamentals
import TCFireSignal
import SkylineDocumentationCore

extension CustCommercialTripsComponents {
    
    static func updateOperador(
        operadorId: UUID,
        operadorType: TipoOperador,
        operadorName: String,
        operadorRfc: String,
        operadorLicens: String,
        operadorMobile: String,
        callback: @escaping ((_ resp: APIResponse?) -> ())
    ) {
        sendPost(
            rout,
            version,
            "updateOperador",
            UpdateOperadorRequest(
                operadorId: operadorId,
                operadorType: operadorType,
                operadorName: operadorName,
                operadorRfc: operadorRfc,
                operadorLicens: operadorLicens,
                operadorMobile: operadorMobile
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
