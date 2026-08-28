import Foundation
import TCFundamentals
import TCFireSignal
import SkylineDocumentationCore

extension CustCommercialTripsComponents {
    
    static func createOperador(
        operadorType: TipoOperador,
        operadorName: String,
        operadorRfc: String,
        operadorLicens: String,
        operadorMobile: String,
        avatar: String? = nil,
        callback: @escaping ((_ resp: APIResponseGeneric<CreateOperadorResponse>?) -> ())
    ) {
        sendPost(
            rout,
            version,
            "createOperador",
            CreateOperadorRequest(
                operadorType: operadorType,
                operadorName: operadorName,
                operadorRfc: operadorRfc,
                operadorLicens: operadorLicens,
                operadorMobile: operadorMobile,
                avatar: avatar
            )
        ) { data in
            
            guard let data else {
                callback(nil)
                return
            }
            
            do {
                callback(try decodeAPIResponse(APIResponseGeneric<CreateOperadorResponse>.self, from: data))
            }
            catch {
                callback(nil)
            }
        }
    }
}
