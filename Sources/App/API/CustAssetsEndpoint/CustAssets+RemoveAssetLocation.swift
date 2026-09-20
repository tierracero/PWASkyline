import Foundation
import TCFundamentals
import TCFireSignal

extension CustAssetsComponents {

    static func removeAssetLocation(
        locationId: UUID,
        callback: @escaping ((_ resp: APIResponse?) -> ())
    ) {
        sendPost(
            rout,
            version,
            "removeAssetLocation",
            RemoveAssetLocationRequest(locationId: locationId)
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
