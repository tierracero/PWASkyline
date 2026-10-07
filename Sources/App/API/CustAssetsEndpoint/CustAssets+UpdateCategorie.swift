import Foundation
import TCFundamentals
import TCFireSignal

extension CustAssetsComponents {

    static func updateCategorie(
        catid: UUID,
        name: String,
        smallDescription: String,
        description: String,
        icon: String,
        coverLandscape: String,
        coverPortrait: String,
        callback: @escaping ((_ resp: APIResponseGeneric<CustGeneralNotes>?) -> ())
    ) {
        sendPost(
            rout,
            version,
            "updateCategorie",
            UpdateCategorieRequest(
                catid: catid,
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
