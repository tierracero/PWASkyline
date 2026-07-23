import Foundation
import TCFundamentals
import TCFireSignal
import SkylineDocumentationCore

extension CustCommercialTripsComponents {
    
    static func getInsurance(
        insuranceId: UUID,
        callback: @escaping ((_ resp: APIResponseGeneric<GetInsuranceResponse>?) -> ())
    ) {
        sendPost(
            rout,
            version,
            "getInsurance",
            GetInsuranceRequest(insuranceId: insuranceId)
        ) { data in
            
            guard let data else {
                callback(nil)
                return
            }
            
            do {
                callback(try decodeAPIResponse(APIResponseGeneric<GetInsuranceResponse>.self, from: data))
            }
            catch {
                callback(nil)
            }
        }
    }
}
