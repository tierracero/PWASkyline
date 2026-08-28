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
        vehicalYear: String,
        vehicalModel: String,
        vehicalMake: String,
        vehicalWeight: Double,
        requierTrailer: Bool,
        insurancePolicy: String? = nil,
        avatar: String? = nil,
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
                vehicalYear: vehicalYear,
                vehicalModel: vehicalModel,
                vehicalMake: vehicalMake,
                vehicalWeight: vehicalWeight,
                requierTrailer: requierTrailer,
                insurancePolicy: insurancePolicy,
                avatar: avatar
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
