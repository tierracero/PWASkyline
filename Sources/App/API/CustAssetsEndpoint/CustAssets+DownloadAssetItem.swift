import Foundation
import TCFundamentals
import TCFireSignal

extension CustAssetsComponents {

    static func downloadAssetItem(
        assetItemId: UUID,
        callback: @escaping ((_ resp: APIResponseGeneric<DownloadAssetItemResponse>?) -> ())
    ) {
        sendPost(
            rout,
            version,
            "downloadAssetItem",
            DownloadAssetItemRequest(assetItemId: assetItemId)
        ) { data in
            guard let data else {
                callback(nil)
                return
            }

            do {
                callback(try decodeAPIResponse(
                    APIResponseGeneric<DownloadAssetItemResponse>.self,
                    from: data
                ))
            }
            catch {
                callback(nil)
            }
        }
    }
}
