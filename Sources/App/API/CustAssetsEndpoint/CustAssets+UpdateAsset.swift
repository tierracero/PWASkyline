import Foundation
import TCFundamentals
import TCFireSignal

extension CustAssetsComponents {

    static func updateAsset(
        assetId: UUID,
        assetType: CustCommercialAssetsType,
        assetDepartmentId: UUID,
        assetSeccionId: UUID? = nil,
        custAcct: UUID? = nil,
        fiscCode: String,
        fiscUnit: String,
        width: String,
        height: String,
        length: String,
        weight: String,
        productType: String,
        productSubType: String,
        upc: String? = nil,
        name: String,
        description: String,
        brand: String,
        model: String,
        pseudoModel: String,
        generalDescription: String,
        comertialDescription: String,
        tecnicalDescription: String,
        initialCost: Int64,
        depreciationRate: Double,
        avatar: String? = nil,
        status: CustCommercialAssetsStatus,
        callback: @escaping ((_ resp: APIResponseGeneric<CustGeneralNotes>?) -> ())
    ) {
        sendPost(
            rout,
            version,
            "updateAsset",
            UpdateAssetRequest(
                assetId: assetId,
                assetType: assetType,
                assetDepartmentId: assetDepartmentId,
                assetSeccionId: assetSeccionId,
                custAcct: custAcct,
                fiscCode: fiscCode,
                fiscUnit: fiscUnit,
                width: width,
                height: height,
                length: length,
                weight: weight,
                productType: productType,
                productSubType: productSubType,
                upc: upc,
                name: name,
                description: description,
                brand: brand,
                model: model,
                pseudoModel: pseudoModel,
                generalDescription: generalDescription,
                comertialDescription: comertialDescription,
                tecnicalDescription: tecnicalDescription,
                initialCost: initialCost,
                depreciationRate: depreciationRate,
                avatar: avatar,
                status: status
            )
        ) { data in
            guard let data else {
                callback(nil)
                return
            }

            do {
                callback(try decodeAPIResponse(
                    APIResponseGeneric<CustGeneralNotes>.self,
                    from: data
                ))
            }
            catch {
                callback(nil)
            }
        }
    }
}
