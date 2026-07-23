import Foundation
import TCFundamentals
import TCFireSignal
import SkylineDocumentationCore

extension CustCommercialTripsComponents {
    
    static func updateMerchandise(
        id: UUID,
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
        callback: @escaping ((_ resp: APIResponse?) -> ())
    ) {
        sendPost(
            rout,
            version,
            "updateMerchandise",
            UpdateMerchandiseRequest(
                id: id,
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
                callback(try decodeAPIResponse(APIResponse.self, from: data))
            }
            catch {
                callback(nil)
            }
        }
    }
}
