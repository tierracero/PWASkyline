import Foundation
import TCFundamentals
import TCFireSignal

extension CustAssetsComponents {

    static func updateAssetSubLocation(
        subLocationId: UUID,
        name: String,
        avatar: String? = nil,
        callback: @escaping ((_ resp: APIResponse?) -> ())
    ) {
        sendPost(
            rout,
            version,
            "updateAssetSubLocation",
            UpdateAssetSubLocationRequest(
                subLocationId: subLocationId,
                name: name,
                avatar: avatar
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
