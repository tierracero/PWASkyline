import Foundation
import TCFundamentals
import TCFireSignal

extension CustAssetsComponents {

    static func getDepartment(
        depid: UUID,
        callback: @escaping ((_ resp: APIResponseGeneric<CustAssetDeps>?) -> ())
    ) {
        sendPost(
            rout,
            version,
            "getDepartment",
            GetDepartmentRequest(depid: depid)
        ) { data in
            guard let data else {
                callback(nil)
                return
            }

            do {
                callback(try decodeAPIResponse(
                    APIResponseGeneric<CustAssetDeps>.self,
                    from: data
                ))
            }
            catch {
                callback(nil)
            }
        }
    }
}
