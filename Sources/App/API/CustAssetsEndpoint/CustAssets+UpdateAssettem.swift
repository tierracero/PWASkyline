import Foundation
import TCFundamentals
import TCFireSignal

extension CustAssetsComponents {

    static func updateAssettem(
        assetItemId: UUID,
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
        disposedAt: Int64?,
        disposedReason: String?,
        status: CustCommercialAssetsItemStatus,
        callback: @escaping ((_ resp: APIResponse?) -> ())
    ) {
        sendPost(
            rout,
            version,
            "updateAssettem",
            UpdateAssettemRequest(
                assetItemId: assetItemId,
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
                disposedAt: disposedAt,
                disposedReason: disposedReason,
                status: status
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
