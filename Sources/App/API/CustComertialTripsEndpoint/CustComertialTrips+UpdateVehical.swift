import Foundation
import TCFundamentals
import TCFireSignal
import SkylineDocumentationCore

extension CustCommercialTripsComponents {
    
    static func updateVehical(
        vehicalId: UUID,
        autotransporteCode: String,
        autotransporteName: String,
        vehicalType: String,
        vehicalTypeName: String,
        vehicalLicensePlate: String,
        vehicalYearModel: String,
        vehicalWeight: Double,
        requierTrailer: Bool,
        callback: @escaping ((_ resp: APIResponse?) -> ())
    ) {
        sendPost(
            rout,
            version,
            "updateVehical",
            UpdateVehicalRequest(
                vehicalId: vehicalId,
                autotransporteCode: autotransporteCode,
                autotransporteName: autotransporteName,
                vehicalType: vehicalType,
                vehicalTypeName: vehicalTypeName,
                vehicalLicensePlate: vehicalLicensePlate,
                vehicalYearModel: vehicalYearModel,
                vehicalWeight: vehicalWeight,
                requierTrailer: requierTrailer
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
