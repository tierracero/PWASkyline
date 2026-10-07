import Foundation
import TCFundamentals
import TCFireSignal

extension CustAssetsComponents {

    static func createAssettem(
        type: InitiateAssetItemViewType,
        purchasFiscalDocumentFolio: String,
        purchasFiscalDocumentId: UUID?,
        commercialAssetId: UUID,
        department: UUID?,
        categorie: UUID?,
        subcategorie: UUID?,
        items: [CreateAssetItemObject],
        callback: @escaping ((_ resp: APIResponseGeneric<CreateAssetItemResponse>?) -> ())
    ) {
        sendPost(
            rout,
            version,
            "createAssettem",
            CreateAssetItemRequest(
                type: type,
                purchasFiscalDocumentFolio: purchasFiscalDocumentFolio,
                purchasFiscalDocumentId: purchasFiscalDocumentId,
                commercialAssetId: commercialAssetId,
                department: department,
                categorie: categorie,
                subcategorie: subcategorie,
                items: items
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
