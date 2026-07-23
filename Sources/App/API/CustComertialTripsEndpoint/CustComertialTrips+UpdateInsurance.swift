import Foundation
import TCFundamentals
import TCFireSignal
import SkylineDocumentationCore

extension CustCommercialTripsComponents {
    
    static func updateInsurance(
        id: UUID,
        validAt: Int64,
        expiredAt: Int64,
        policyNumber: String,
        provider: String,
        providerPhone: String,
        insuredAmount: Int64,
        callback: @escaping ((_ resp: APIResponse?) -> ())
    ) {
        sendPost(
            rout,
            version,
            "updateInsurance",
            UpdateInsuranceRequest(
                id: id,
                validAt: validAt,
                expiredAt: expiredAt,
                policyNumber: policyNumber,
                provider: provider,
                providerPhone: providerPhone,
                insuredAmount: insuredAmount
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
