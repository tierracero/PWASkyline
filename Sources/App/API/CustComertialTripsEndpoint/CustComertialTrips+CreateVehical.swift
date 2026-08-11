import Foundation
import TCFundamentals
import TCFireSignal
import SkylineDocumentationCore

extension CustCommercialTripsComponents {
    
    static func createVehical(
        autotransporteCode: String,
        autotransporteName: String,
        vehicalType: String,
        vehicalTypeName: String,
        vehicalLicensePlate: String,
        vehicalYearModel: String,
        vehicalWeight: Double,
        requierTrailer: Bool,
        insurancePolicy: String? = nil,
        callback: @escaping ((_ resp: APIResponseGeneric<CreateVehicalResponse>?) -> ())
    ) {
        sendPost(
            rout,
            version,
            "createVehical",
            CreateVehicalRequest(
                autotransporteCode: autotransporteCode,
                autotransporteName: autotransporteName,
                vehicalType: vehicalType,
                vehicalTypeName: vehicalTypeName,
                vehicalLicensePlate: vehicalLicensePlate,
                vehicalYearModel: vehicalYearModel,
                vehicalWeight: vehicalWeight,
                requierTrailer: requierTrailer,
                insurancePolicy: insurancePolicy
            )
        ) { data in
            
            guard let data else {
                callback(nil)
                return
            }
            
            do {
                callback(try decodeAPIResponse(APIResponseGeneric<CreateVehicalResponse>.self, from: data))
            }
            catch {
                callback(nil)
            }
        }
    }
}
