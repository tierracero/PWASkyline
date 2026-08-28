import Foundation
import TCFundamentals
import TCFireSignal

extension CustAssetsComponents {

    static func getAssettem(
        assetItemId: UUID,
        callback: @escaping ((_ resp: APIResponseGeneric<GetAssettemResponse>?) -> ())
    ) {
        sendPost(
            rout,
            version,
            "getAssettem",
            GetAssettemRequest(assetItemId: assetItemId)
        ) { data in
            guard let data else {
                callback(nil)
                return
            }

            do {
                callback(try decodeAPIResponse(
                    APIResponseGeneric<GetAssettemResponse>.self,
                    from: data
                ))
            }
            catch {
                callback(nil)
            }
        }
    }
}
