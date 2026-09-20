import Foundation
import TCFundamentals
import TCFireSignal

extension CustAssetsComponents {

    static func removeAssetSubLocation(
        subLocationId: UUID,
        callback: @escaping ((_ resp: APIResponse?) -> ())
    ) {
        sendPost(
            rout,
            version,
            "removeAssetSubLocation",
            RemoveAssetSubLocationRequest(subLocationId: subLocationId)
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
