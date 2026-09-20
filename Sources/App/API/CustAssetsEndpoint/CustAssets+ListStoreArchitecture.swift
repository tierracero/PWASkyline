import TCFundamentals
import TCFireSignal
import Foundation

extension CustAssetsComponents {

    static func listStoreArchitecture(
        relationId: UUID,
        callback: @escaping ((_ resp: APIResponseGeneric<ListStoreArchitectureResponse>?) -> ())
    ) {
        sendPost(
            rout,
            version,
            "listStoreArchitecture",
            ListStoreArchitectureRequest(
                relationId: relationId
            )
        ) { data in
            guard let data else {
                callback(nil)
                return
            }

            do {
                callback(try decodeAPIResponse(
                    APIResponseGeneric<ListStoreArchitectureResponse>.self,
                    from: data
                ))
            }
            catch {
                callback(nil)
            }
        }
    }
}
