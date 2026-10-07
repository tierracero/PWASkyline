import Foundation
import TCFundamentals
import TCFireSignal

extension CustAssetsComponents {

    static func createAsset(
        assetType: CustCommercialAssetsType,
        assetDepartmentId: UUID,
        assetSeccionId: UUID?,
        custAcct: UUID?,
        fiscCode: String,
        fiscUnit: String,
        width: String,
        height: String,
        length: String,
        weight: String,
        productType: String,
        productSubType: String,
        upc: String?,
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
        avatar: String?,
        callback: @escaping ((_ resp: APIResponseGeneric<CreateAssetResponse>?) -> ())
    ) {
        sendPost(
            rout,
            version,
            "createAsset",
            CreateAssetRequest(
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
                avatar: avatar
            )
        ) { data in
            guard let data else {
                callback(nil)
                return
            }

            do {
                callback(try decodeAPIResponse(
                    APIResponseGeneric<CreateAssetResponse>.self,
                    from: data
                ))
            }
            catch {
                callback(nil)
            }
        }
    }
}
