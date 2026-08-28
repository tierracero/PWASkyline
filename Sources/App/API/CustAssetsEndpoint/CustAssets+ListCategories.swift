import Foundation
import TCFundamentals
import TCFireSignal

extension CustAssetsComponents {

    static func listCategories(
        depid: UUID? = nil,
        callback: @escaping ((_ resp: APIResponseGeneric<ListCategoriesResponse>?) -> ())
    ) {
        sendPost(
            rout,
            version,
            "listCategories",
            ListCategoriesRequest(depid: depid)
        ) { data in
            guard let data else {
                callback(nil)
                return
            }

            do {
                callback(try decodeAPIResponse(
                    APIResponseGeneric<ListCategoriesResponse>.self,
                    from: data
                ))
            }
            catch {
                callback(nil)
            }
        }
    }
}
