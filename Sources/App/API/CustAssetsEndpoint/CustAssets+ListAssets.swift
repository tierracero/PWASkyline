import Foundation
import TCFundamentals
import TCFireSignal

extension CustAssetsComponents {

    static func listAssets(
        assetDepartmentId: UUID? = nil,
        assetSeccionId: UUID? = nil,
        relationId: UUID? = nil,
        status: CustCommercialAssetsStatus? = nil,
        callback: @escaping ((_ resp: APIResponseGeneric<ListAssetsResponse>?) -> ())
    ) {
        sendPost(
            rout,
            version,
            "listAssets",
            ListAssetsRequest(
                assetDepartmentId: assetDepartmentId,
                assetSeccionId: assetSeccionId,
                relationId: relationId,
                status: status
            )
        ) { data in
            guard let data else {
                callback(nil)
                return
            }

            do {
                callback(try decodeAPIResponse(
                    APIResponseGeneric<ListAssetsResponse>.self,
                    from: data
                ))
            }
            catch {
                callback(nil)
            }
        }
    }
}
