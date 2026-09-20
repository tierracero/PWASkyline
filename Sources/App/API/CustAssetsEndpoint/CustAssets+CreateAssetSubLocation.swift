import Foundation
import TCFundamentals
import TCFireSignal

extension CustAssetsComponents {

    static func createAssetSubLocation(
        commercialAssetsLocationId: UUID,
        name: String,
        avatar: String? = nil,
        callback: @escaping ((_ resp: APIResponseGeneric<CreateAssetSubLocationResponse>?) -> ())
    ) {
        sendPost(
            rout,
            version,
            "createAssetSubLocation",
            CreateAssetSubLocationRequest(
                commercialAssetsLocationId: commercialAssetsLocationId,
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
                    APIResponseGeneric<CreateAssetSubLocationResponse>.self,
                    from: data
                ))
            }
            catch {
                callback(nil)
            }
        }
    }
}
