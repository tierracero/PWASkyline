import Foundation
import TCFundamentals
import TCFireSignal

extension CustAssetsComponents {

    static func removeAsset(
        assetId: UUID,
        callback: @escaping ((_ resp: APIResponse?) -> ())
    ) {
        sendPost(
            rout,
            version,
            "removeAsset",
            RemoveAssetRequest(assetId: assetId)
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
