import Foundation
import TCFundamentals
import TCFireSignal
import SkylineDocumentationCore

extension CustCommercialTripsComponents {
    
    static func createMerchandise(
        fiscCode: String,
        fiscCodeName: String,
        fiscUnit: String,
        fiscUnitName: String,
        description: String,
        units: Int64,
        kilograms: Int64,
        isDangerousMatirial: IsMaterialPeligroso,
        dangerousMatirialCode: String,
        dangerousMatirialName: String,
        packagingType: String,
        packagingName: String,
        callback: @escaping ((_ resp: APIResponseGeneric<CreateMerchandiseResponse>?) -> ())
    ) {
        sendPost(
            rout,
            version,
            "createMerchandise",
            CreateMerchandiseRequest(
                fiscCode: fiscCode,
                fiscCodeName: fiscCodeName,
                fiscUnit: fiscUnit,
                fiscUnitName: fiscUnitName,
                description: description,
                units: units,
                kilograms: kilograms,
                isDangerousMatirial: isDangerousMatirial,
                dangerousMatirialCode: dangerousMatirialCode,
                dangerousMatirialName: dangerousMatirialName,
                packagingType: packagingType,
                packagingName: packagingName
            )
        ) { data in
            
            guard let data else {
                callback(nil)
                return
            }
            
            do {
                callback(try decodeAPIResponse(APIResponseGeneric<CreateMerchandiseResponse>.self, from: data))
            }
            catch {
                callback(nil)
            }
        }
    }
}
