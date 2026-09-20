import Foundation
import TCFundamentals
import TCFireSignal

extension CustAssetsComponents {

    static func updateAssettem(
        assetItemId: UUID,
        section: UUID? = nil,
        subSection: UUID? = nil,
        currentCost: Int64,
        serial: String?,
        name: String,
        callback: @escaping ((_ resp: APIResponse?) -> ())
    ) {
        sendPost(
            rout,
            version,
            "updateAssettem",
            UpdateAssettemRequest(
                assetItemId: assetItemId,
                section: section,
                subSection: subSection,
                currentCost: currentCost,
                serial: serial,
                name: name
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
