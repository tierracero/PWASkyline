import Foundation
import TCFundamentals
import TCFireSignal

extension CustAssetsComponents {

    static func getAssetsSection(
        type: InitiateAssetItemViewType,
        callback: @escaping ((_ resp: APIResponseGeneric<GetAssetsSectionResponse>?) -> ())
    ) {
        sendPost(
            rout,
            version,
            "getAssetsSection",
            GetAssetsSectionRequest(type: type)
        ) { data in
            guard let data else {
                callback(nil)
                return
            }

            do {
                callback(try decodeAPIResponse(
                    APIResponseGeneric<GetAssetsSectionResponse>.self,
                    from: data
                ))
            }
            catch {
                callback(nil)
            }
        }
    }
}
