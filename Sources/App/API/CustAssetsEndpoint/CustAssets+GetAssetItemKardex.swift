import Foundation
import TCFundamentals
import TCFireSignal

extension CustAssetsComponents {

    static func getAssetItemKardex(
        assetItemId: UUID,
        page: Int = 0,
        rows: Int = 50,
        fromCreatedAt: Int64? = nil,
        toCreatedAt: Int64? = nil,
        eventType: CustCommercialAssetsItemKardexEventType? = nil,
        callback: @escaping ((_ resp: APIResponseGeneric<GetAssetItemKardexResponse>?) -> ())
    ) {
        sendPost(
            rout,
            version,
            "getAssetItemKardex",
            GetAssetItemKardexRequest(
                assetItemId: assetItemId,
                page: page,
                rows: rows,
                fromCreatedAt: fromCreatedAt,
                toCreatedAt: toCreatedAt,
                eventType: eventType
            )
        ) { data in
            guard let data else {
                callback(nil)
                return
            }

            do {
                callback(try decodeAPIResponse(
                    APIResponseGeneric<GetAssetItemKardexResponse>.self,
                    from: data
                ))
            }
            catch {
                callback(nil)
            }
        }
    }
}
