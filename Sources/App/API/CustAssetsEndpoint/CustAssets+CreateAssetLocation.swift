import Foundation
import TCFundamentals
import TCFireSignal

extension CustAssetsComponents {

    static func createAssetLocation(
        linkType: CustCommercialAssetsLocationLinkedType,
        linkedTo: UUID,
        name: String,
        avatar: String? = nil,
        callback: @escaping ((_ resp: APIResponseGeneric<CreateAssetLocationResponse>?) -> ())
    ) {
        sendPost(
            rout,
            version,
            "createAssetLocation",
            CreateAssetLocationRequest(
                linkType: linkType,
                linkedTo: linkedTo,
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
                    APIResponseGeneric<CreateAssetLocationResponse>.self,
                    from: data
                ))
            }
            catch {
                callback(nil)
            }
        }
    }
}
