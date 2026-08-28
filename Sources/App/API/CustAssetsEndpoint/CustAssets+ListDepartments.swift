import TCFundamentals
import TCFireSignal
import Foundation

extension CustAssetsComponents {

    static func listDepartments(
        accountId: UUID?,
        callback: @escaping ((_ resp: APIResponseGeneric<ListDepartmentsResponse>?) -> ())
    ) {
        sendPost(
            rout,
            version,
            "listDepartments",
            ListDepartmentsRequest(accountId: accountId)
        ) { data in
            guard let data else {
                callback(nil)
                return
            }

            do {
                callback(try decodeAPIResponse(
                    APIResponseGeneric<ListDepartmentsResponse>.self,
                    from: data
                ))
            }
            catch {
                callback(nil)
            }
        }
    }
}
