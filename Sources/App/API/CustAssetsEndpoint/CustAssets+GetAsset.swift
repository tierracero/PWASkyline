import Foundation
import TCFundamentals
import TCFireSignal

extension CustAssetsComponents {

    static func getAsset(
        assetId: UUID,
        callback: @escaping ((_ resp: APIResponseGeneric<GetAssetResponse>?) -> ())
    ) {
        sendPost(
            rout,
            version,
            "getAsset",
            GetAssetRequest(assetId: assetId)
        ) { data in
            guard let data else {
                callback(nil)
                return
            }

            do {
                callback(try decodeAPIResponse(
                    APIResponseGeneric<GetAssetResponse>.self,
                    from: data
                ))
            }
            catch {
                callback(nil)
            }
        }
    }
}
