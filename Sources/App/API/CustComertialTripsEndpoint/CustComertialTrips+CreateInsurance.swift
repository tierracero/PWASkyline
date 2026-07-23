import Foundation
import TCFundamentals
import TCFireSignal
import SkylineDocumentationCore

extension CustCommercialTripsComponents {
    
    static func createInsurance(
        validAt: Int64,
        expiredAt: Int64,
        type: ComertialTripInsuranceType,
        policyNumber: String,
        provider: String,
        providerPhone: String,
        insuredAmount: Int64,
        callback: @escaping ((_ resp: APIResponseGeneric<CreateInsuranceResponse>?) -> ())
    ) {
        sendPost(
            rout,
            version,
            "createInsurance",
            CreateInsuranceRequest(
                validAt: validAt,
                expiredAt: expiredAt,
                type: type,
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
                callback(try decodeAPIResponse(APIResponseGeneric<CreateInsuranceResponse>.self, from: data))
            }
            catch {
                callback(nil)
            }
        }
    }
}
