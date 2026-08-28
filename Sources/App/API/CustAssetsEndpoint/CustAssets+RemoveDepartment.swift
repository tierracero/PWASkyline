import Foundation
import TCFundamentals
import TCFireSignal

extension CustAssetsComponents {

    static func removeDepartment(
        depid: UUID,
        callback: @escaping ((_ resp: APIResponse?) -> ())
    ) {
        sendPost(
            rout,
            version,
            "removeDepartment",
            RemoveDepartmentRequest(depid: depid)
        ) { data in
            guard let data else {
                callback(nil)
                return
            }

            do {
                callback(try decodeAPIResponse(APIResponse.self, from: data))
            }
            catch {
                callback(nil)
            }
        }
    }
}
