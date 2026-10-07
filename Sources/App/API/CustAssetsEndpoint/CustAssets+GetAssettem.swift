import Foundation
import TCFundamentals
import TCFireSignal

extension CustAssetsComponents {

    static func getAssetItem(
        assetItemId: UUID,
        callback: @escaping ((_ resp: APIResponseGeneric<GetAssetItemResponse>?) -> ())
    ) {
        sendPost(
            rout,
            version,
            "GetAssetItem",
            GetAssetItemRequest(assetItemId: assetItemId)
        ) { data in
            guard let data else {
                callback(nil)
                return
            }

            do {
                callback(try decodeAPIResponse(
                    APIResponseGeneric<GetAssetItemResponse>.self,
                    from: data
                ))
            }
            catch {
                callback(nil)
            }
        }
    }
}
