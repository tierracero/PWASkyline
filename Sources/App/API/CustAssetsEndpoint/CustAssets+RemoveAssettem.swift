import Foundation
import TCFundamentals
import TCFireSignal

extension CustAssetsComponents {

    static func removeAssettem(
        assetItemId: UUID,
        disposedReason: String? = nil,
        correlationId: UUID = .init(),
        callback: @escaping ((_ resp: APIResponse?) -> ())
    ) {
        sendPost(
            rout,
            version,
            "removeAssettem",
            RemoveAssettemRequest(
                assetItemId: assetItemId,
                disposedReason: disposedReason,
                correlationId: correlationId
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
