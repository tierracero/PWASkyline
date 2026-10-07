import Foundation
import TCFundamentals
import TCFireSignal

extension CustAssetsComponents {

    static func updateAssetLocation(
        locationId: UUID,
        name: String,
        avatar: String? = nil,
        callback: @escaping ((_ resp: APIResponseGeneric<CustGeneralNotes>?) -> ())
    ) {
        sendPost(
            rout,
            version,
            "updateAssetLocation",
            UpdateAssetLocationRequest(
                locationId: locationId,
                name: name,
                avatar: avatar
            )
        ) { data in
            guard let data else {
                callback(nil)
                return
            }

            do {
                callback(try decodeAPIResponse(
                    APIResponseGeneric<CustGeneralNotes>.self,
                    from: data
                ))
            }
            catch {
                callback(nil)
            }
        }
    }
}
