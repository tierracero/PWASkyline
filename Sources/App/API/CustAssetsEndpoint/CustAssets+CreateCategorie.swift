import Foundation
import TCFundamentals
import TCFireSignal

extension CustAssetsComponents {

    static func createCategorie(
        custAssetDeps: UUID,
        name: String,
        smallDescription: String,
        description: String,
        icon: String,
        coverLandscape: String,
        coverPortrait: String,
        callback: @escaping ((_ resp: APIResponseGeneric<CreateCategorieResponse>?) -> ())
    ) {
        sendPost(
            rout,
            version,
            "createCategorie",
            CreateCategorieRequest(
                custAssetDeps: custAssetDeps,
                name: name,
                smallDescription: smallDescription,
                description: description,
                icon: icon,
                coverLandscape: coverLandscape,
                coverPortrait: coverPortrait
            )
        ) { data in
            guard let data else {
                callback(nil)
                return
            }

            do {
                callback(try decodeAPIResponse(
                    APIResponseGeneric<CreateCategorieResponse>.self,
                    from: data
                ))
            }
            catch {
                callback(nil)
            }
        }
    }
}
