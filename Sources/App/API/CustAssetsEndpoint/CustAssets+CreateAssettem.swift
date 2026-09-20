import Foundation
import TCFundamentals
import TCFireSignal

extension CustAssetsComponents {

    static func createAssettem(
        purchasFiscalDocumentFolio: String,
        purchasFiscalDocumentId: UUID?,
        commercialAssetId: UUID,
        owningStore: UUID,
        owningAccount: UUID?,
        currentLocation: CustCommercialAssetsLinkedType,
        currentLocationId: UUID,
        department: UUID?,
        categorie: UUID?,
        subcategorie: UUID?,
        section: UUID? = nil,
        subSection: UUID? = nil,
        acquisitionAt: Int64,
        acquisitionCost: Int64,
        currentCost: Int64,
        serial: String?,
        name: String,
        latitude: Double?,
        longitude: Double?,
        serviceCard: String?,
        images: [String],
        correlationId: UUID = .init(),
        callback: @escaping ((_ resp: APIResponseGeneric<CreateAssetItemResponse>?) -> ())
    ) {
        sendPost(
            rout,
            version,
            "createAssettem",
            CreateAssetItemRequest(
                purchasFiscalDocumentFolio: purchasFiscalDocumentFolio,
                purchasFiscalDocumentId: purchasFiscalDocumentId,
                commercialAssetId: commercialAssetId,
                owningStore: owningStore,
                owningAccount: owningAccount,
                currentLocation: currentLocation,
                currentLocationId: currentLocationId,
                department: department,
                categorie: categorie,
                subcategorie: subcategorie,
                section: section,
                subSection: subSection,
                acquisitionAt: acquisitionAt,
                acquisitionCost: acquisitionCost,
                currentCost: currentCost,
                serial: serial,
                name: name,
                latitude: latitude,
                longitude: longitude,
                serviceCard: serviceCard,
                images: images,
                correlationId: correlationId
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
