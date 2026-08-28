import Foundation
import TCFundamentals
import TCFireSignal

extension CustAssetsComponents {

    static func getCategorie(
        catid: UUID,
        callback: @escaping ((_ resp: APIResponseGeneric<CustAssetCats>?) -> ())
    ) {
        sendPost(
            rout,
            version,
            "getCategorie",
            GetCategorieRequest(catid: catid)
        ) { data in
            guard let data else {
                callback(nil)
                return
            }

            do {
                callback(try decodeAPIResponse(
                    APIResponseGeneric<CustAssetCats>.self,
                    from: data
                ))
            }
            catch {
                callback(nil)
            }
        }
    }
}
