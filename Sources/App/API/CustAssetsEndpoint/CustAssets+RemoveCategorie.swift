import Foundation
import TCFundamentals
import TCFireSignal

extension CustAssetsComponents {

    static func removeCategorie(
        catid: UUID,
        callback: @escaping ((_ resp: APIResponse?) -> ())
    ) {
        sendPost(
            rout,
            version,
            "removeCategorie",
            RemoveCategorieRequest(catid: catid)
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
