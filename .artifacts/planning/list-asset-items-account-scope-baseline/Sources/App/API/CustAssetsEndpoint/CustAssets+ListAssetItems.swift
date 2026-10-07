import Foundation
import TCFundamentals
import TCFireSignal

extension CustAssetsComponents {

    static func listAssetItems(
        currentLocation: ListAssetItemsType,
        departmentId: UUID?,
        categorieId: UUID?,
        status: ListSubAccountItemsStatus,
        callback: @escaping ((_ resp: APIResponseGeneric<ListAssetItemsResponse>?) -> ())
    ) {
        sendPost(
            rout,
            version,
            "listAssetItems",
            ListAssetItemsRequest(
                currentLocation: currentLocation,
                departmentId: departmentId,
                categorieId: categorieId,
                status: status
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
