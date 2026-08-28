import Foundation
import TCFundamentals
import TCFireSignal

extension CustAssetsComponents {

    static func createAssettem(
        purchasFiscalDocumentFolio: String,
        purchasFiscalDocumentId: UUID?,
        commercialAssetsId: UUID,
        linkType: CustCommercialAssetsLinkedType,
        linkedTo: UUID,
        department: UUID?,
        categorie: UUID?,
        subcategorie: UUID?,
        acquisitionAt: Int64,
        acquisitionCost: Int64,
        currentCost: Int64,
        serial: String?,
        name: String,
        latitude: Double?,
        longitude: Double?,
        serviceCard: String?,
        images: [String],
        callback: @escaping ((_ resp: APIResponseGeneric<CreateAssetItemResponse>?) -> ())
    ) {
        sendPost(
            rout,
            version,
            "createAssettem",
            CreateAssetItemRequest(
                purchasFiscalDocumentFolio: purchasFiscalDocumentFolio,
                purchasFiscalDocumentId: purchasFiscalDocumentId,
                commercialAssetsId: commercialAssetsId,
                linkType: linkType,
                linkedTo: linkedTo,
                department: department,
                categorie: categorie,
                subcategorie: subcategorie,
                acquisitionAt: acquisitionAt,
                acquisitionCost: acquisitionCost,
                currentCost: currentCost,
                serial: serial,
                name: name,
                latitude: latitude,
                longitude: longitude,
                serviceCard: serviceCard,
                images: images
            )
        ) { data in
            guard let data else {
                callback(nil)
                return
            }

            do {
                callback(try decodeAPIResponse(
                    APIResponseGeneric<CreateAssetItemResponse>.self,
                    from: data
                ))
            }
            catch {
                callback(nil)
            }
        }
    }
}
