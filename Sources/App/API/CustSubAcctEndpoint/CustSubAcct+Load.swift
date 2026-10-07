import Foundation
import TCFundamentals
import TCFireSignal

extension CustSubAcctComponents {
    public static func load(
        id: HybridIdentifier,
        callback: @escaping (APIResponseGeneric<LoadResponse>?) -> Void
    ) {
        sendPost(rout, version, "load", LoadRequest(id: id)) { data in
            guard let data else {
                callback(nil)
                return
            }

            do {
                callback(try decodeAPIResponse(APIResponseGeneric<LoadResponse>.self, from: data))
            } catch {
                callback(nil)
            }
        }
    }
}
