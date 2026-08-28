import Foundation
import TCFundamentals
import TCFireSignal

extension CustAssetsComponents {

    static func listAssetItems(
        type: String,
        id: UUID,
        callback: @escaping ((_ resp: APIResponseGeneric<ListAssetItemsResponse>?) -> ())
    ) {
        sendPost(
            rout,
            version,
            "listAssetItems",
            ListAssetItemsRequest(
                type: type,
                id: id
            )
        ) { data in
            guard let data else {
                callback(nil)
                return
            }

            do {
                callback(try decodeAPIResponse(
                    APIResponseGeneric<ListAssetItemsResponse>.self,
                    from: data
                ))
            }
            catch {
                callback(nil)
            }
        }
    }
}
